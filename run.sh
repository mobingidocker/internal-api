#!/bin/bash
source /etc/profile.d/rbenv.sh

echo "Ruby Rehash"
rbenv rehash

echo "Ruby Version:"
ruby -v

cd /api
bundle exec ruby api.rb > /var/log/api.log 2>&1

