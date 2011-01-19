#
# Cookbook Name:: apps
# Recipe:: default
#
# Copyright 2011, Verdeeco
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"

group "apps" do
  gid 400
end

user "apps" do
  uid 400
  gid 400
  shell "/bin/bash"
  home "/home/apps"
end

directory "/home/apps/.ssh" do
  owner "apps"
  group "apps"
  mode "0755"
  action :create
  recursive true
end

apps = data_bag("apps")

apps.each do |app|  
  data = data_bag_item("apps", app)

  # install os deps
  if data["dependencies"]["os"]
    data["dependencies"]["os"].each do |dep|
      package dep
    end
  end
  
  # install python deps
  if data["dependencies"]["python"]
    include_recipe "python"
    
    data["dependencies"]["python"].each do |dep|
      easy_install_package dep
    end
  end

  template "/home/apps/.ssh/id_rsa" do
    source "id_rsa.erb"
    mode 0600
    owner "apps"
    group "apps"
    variables :deploy_key => data["git"]["deploy_key"]
  end
  
  directory "/opt/verdeeco" do
    owner "apps"
    group "apps"
    mode "0755"
    action :create
  end
  
  git data["path"] do
    repository data["git"]["repo"]
    reference "HEAD"
    revision data["git"]["branch"]
    action :checkout
    user "apps"
  end
  
  runit_service app do
    template_name "apps"
    options data
  end
  
  template "/etc/nginx/sites-available/#{app}" do
    source "nginx_app.erb"
    variables :config => data["nginx"]["config"]
    notifies :reload, resources(:service => "nginx")
  end
  
  case data["nginx"]["status"]
  when "enabled"
    nginx_site app do
      enable true
    end
  when "disabled"
    nginx_site app do
      enable false
    end
  end
  
end