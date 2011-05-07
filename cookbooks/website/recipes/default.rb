#
# Cookbook Name:: website
# Recipe:: default
#
# Copyright 2011, Verdeeco
#
# All rights reserved - Do Not Redistribute
#

include_recipe "base"
include_recipe "nginx"
include_recipe "apps"

deploy_key = data_bag_item("deploy_keys", "gaas")

directory "/var/www/.ssh" do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

template "/var/www/.ssh/id_rsa" do
  source "id_rsa.erb"
  mode 0600
  owner "www-data"
  group "www-data"
  variables :deploy_key => deploy_key
end

# TODO This needs to be moved out globally
# We're doing this same thing in two recipes
# Ripe for failure if we forget to update one and not the other
cookbook_file "/var/www/.ssh/known_hosts" do
  source "known_hosts"
  mode 0644
  owner "www-data"
  group "www-data"
end

directory "/var/www/domains/verdeeco.com" do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

git "/var/www/domains/verdeeco.com/htdocs" do
  repository "git@github.com:verdeeco/gaas.git"
  reference "master"
  action :sync
  user "www-data"
end

template "/etc/nginx/sites-available/website" do
  source "website.erb"
  mode 0600
  owner "root"
  group "root"
  notifies :reload, resources(:service => "nginx")
end

nginx_site "website"
