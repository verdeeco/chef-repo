#
# Cookbook Name:: website
# Recipe:: default
#
# Copyright 2011, Verdeeco
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"

deploy_key = data_bag_item("deploy_keys", "website")

template "/var/www/.ssh/id_rsa" do
  source "id_rsa.erb"
  mode 0600
  owner "www-data"
  group "www-data"
  variables :deploy_key => deploy_key
end

directory "/var/www/domains/verdeeco.com/htdocs" do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

git "/var/www/domains/verdeeco.com/htdocs" do
  repository "git@github.com:verdeeco/website.git"
  reference "HEAD"
  revision "master"
  action :checkout
  user "www-data"
  not_if "/usr/bin/test -d /var/www/website"
end

runit_service "website"

template "/etc/nginx/sites-available/website" do
  source "website.erb"
  mode 0600
  owner "root"
  group "root"
  notifies :reload, resources(:service => "nginx")
end

nginx_site "website"