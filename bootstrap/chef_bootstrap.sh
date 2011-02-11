#!/usr/bin/bash

apt-get update
apt-get install --force-yes -y ruby rubygems ruby1.8-dev libopenssl-ruby1.8 build-essential curl wget runit
gem install chef --no-rdoc --no-ri
ln -sfv /var/lib/gems/1.8/bin/chef-client /usr/bin/chef-client

mkdir /etc/chef

curl https://s3.amazonaws.com/verdeeco.bootstrap/client.rb > /etc/chef/client.rb
curl https://s3.amazonaws.com/verdeeco.bootstrap/validation.pem > /etc/chef/validation.pem

chmod 600 /etc/chef/validation.pem

chef-client

rm /etc/chef/validation.pem