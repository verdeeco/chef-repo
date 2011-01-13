#
# Cookbook Name:: apps
# Recipe:: default
#
# Copyright 2011, Verdeeco
#
# All rights reserved - Do Not Redistribute
#


apps = data_bag("apps")

apps.each do |app|  
  data = data_bag_item("apps", app)

  if data["dependencies"]["python"]
    include_recipe "python"
    
    data["dependencies"]["python"].each do |dep|
      easy_install_package dep
    end
  end

  template "/root/.ssh/id_rsa" do
    source "id_rsa.erb"
    mode 0600
    owner "root"
    group "root"
    variables :deploy_keys => data["git"]["deploy_key"]
  end
  
  git data["path"] do
    repository data["git"]["repo"]
    reference "HEAD"
    revision data["git"]["branch"]
    action :checkout
    user "root"
  end
  
  runit_service app do
    template_name "apps"
    options data
  end
  
end