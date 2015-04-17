#!/bin/bash
source /etc/profile.d/rbenv.sh

echo "Ruby Rehash"
rbenv rehash

echo "Ruby Version:"
ruby -v

cd /api
bundle exec ruby api.rb 2>&1 > /var/log/api.log

