#
# Cookbook Name:: website
# Recipe:: default
#
# Copyright 2011, Verdeeco
#
# All rights reserved - Do Not Redistribute
#

## TODO: deploy keys via databags

#deploy_keys = data_bag_item("deploy_keys", "website")

#template "/root/.ssh/id_rsa" do
#  source "id_rsa.erb"
#  mode 0600
#  owner "root"
#  group "root"
#  variables :deploy_keys => deploy_keys
#end

git "/var/www/website" do
  repository "git@github.com:verdeeco/website.git"
  reference "HEAD"
  revision "master"
  action :checkout
  user "root"
  not_if "/usr/bin/test -d /var/www/website"
end

runit_service "website"
nginx_site "website"