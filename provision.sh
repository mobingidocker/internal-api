
apt-get update
apt-get install -y ruby git build-essential curl wget libcurl4-openssl-dev

#Install rbenv
git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv

# Add rbenv to the path:
echo '# rbenv setup' > /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
 
chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh
 
# Install ruby-build:
pushd /tmp
  git clone https://github.com/sstephenson/ruby-build.git
  cd ruby-build
  ./install.sh
popd

rbenv install 2.2.10

rbenv global 2.2.10

gem install bundler

pushd /api

  bundle install

popd
