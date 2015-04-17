require 'sinatra'
require 'thin'
require 'json'
require 'aws-sdk'

configure do
  set :environment, :production
  set :bind, '0.0.0.0'
  set :port, 4567
  set :server, "thin"
end

def credentials
  credentials = {
    region: ENV['AWS_REGION'], 
    access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }

  if ENV['AWS_SESSION_TOKEN']

    credentials = {
      region: ENV['AWS_REGION'], 
      access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      session_token: ENV['AWS_SESSION_TOKEN']
    }
  end

  return credentials
end

get '/' do
  ["stack"].to_json
end

get '/stack/?' do
  ["name", "instances"].to_json
end

get '/stack/name/?' do
  ENV['MOCLOUD_STACK_ID'].to_json
end

get '/stack/instances/?' do
  

  cf = Aws::CloudFormation::Client.new(credentials)
  as = Aws::AutoScaling::Client.new(credentials)
  
  
  desc = cf.describe_stack_resources(stack_name: ENV['MOCLOUD_STACK_ID']) 
  asgid = desc[:stack_resources].find { |x| x[:logical_resource_id] == "DockerServersInDockerLayer" }[:physical_resource_id]

  result = as.describe_auto_scaling_instances()[:auto_scaling_instances].
    select { |x| x[:auto_scaling_group_name] == asgid }.
    map { |x| x[:instance_id] }

    result.to_json
end

get '/stack/instances/:instance/?' do
  ec2 = Aws::EC2::Client.new(credentials)

  begin
    resp = ec2.describe_instances(instance_ids: [params[:instance]])
  rescue
    status 404
    return [].to_json
  end

  ["state", "privateip", "publicip"].to_json
end

get '/stack/instances/:instance/state' do
  ec2 = Aws::EC2::Client.new(credentials)

  begin
    resp = ec2.describe_instances(instance_ids: [params[:instance]])[:reservations][0][:instances][0][:state][:name]

    return resp.to_json
  rescue
    status 404
    return "[]".to_json
  end

end

get '/stack/instances/:instance/privateip' do
  ec2 = Aws::EC2::Client.new(credentials)

  begin
    resp = ec2.describe_instances(instance_ids: [params[:instance]])[:reservations][0][:instances][0][:private_ip_address]

    return resp.to_json
  rescue
    status 404
    return "[]".to_json
  end

end

get '/stack/instances/:instance/publicip' do
  ec2 = Aws::EC2::Client.new(credentials)

  begin
    resp = ec2.describe_instances(instance_ids: [params[:instance]])[:reservations][0][:instances][0][:public_ip_address]

    return resp.to_json
  rescue
    status 404
    return "[]".to_json
  end

end
