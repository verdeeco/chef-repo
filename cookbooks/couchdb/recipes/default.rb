
include_recipe "libicu"
include_recipe "spidermonkey"
include_recipe "runit"

group "couchdb" do
  gid 400
end

user "couchdb" do
  uid 400
  gid 400
  shell "/bin/bash"
  home node[:couchdb][:home_dir]
end

directory node[:couchdb][:home_dir] do
  owner "couchdb"
  group "couchdb"
  mode "0755"
end

template "#{node[:couchdb][:home_dir]}/.erlang.cookie" do
  source "erlang_cookie.erb"
  mode 0400
  owner "couchdb"
  group "couchdb"
end

directory "#{node[:couchdb][:data_path]}/db" do
  owner "couchdb"
  group "couchdb"
  mode "0755"
  recursive true
end

directory "#{node[:couchdb][:data_path]}/view_index" do
  owner "couchdb"
  group "couchdb"
  mode "0755"
  recursive true
end

template "#{node[:couchdb][:install_path]}/etc/default.ini" do
  source "default.ini.erb"
  owner "couchdb"
  group "couchdb"
  mode 0644
end
 
template "#{node[:couchdb][:install_path]}/etc/vm.args" do
  source "vm.args.erb"
  owner "couchdb"
  group "couchdb"
  mode 0644
end

filename = "couchdb_#{node[:couchdb][:version]}_#{node[:couchdb][:erlang][:version]}_#{node[:couchdb][:machine]}.tar.gz"

remote_file "/tmp/#{filename}" do
  source "#{node[:couchdb][:repo_url]}/#{filename}"
  mode 0644
  owner "couchdb"
  group "couchdb"
  not_if "/usr/bin/test -d #{node[:couchdb][:install_path]}"
end

bash "install couchdb" do
  user "root"
  cwd "/opt"
  code <<-EOH
  (tar zxf /tmp/#{filename} -C /opt)
  (rm -f /tmp/#{filename})
  (chown -R couchdb:couchdb #{node[:couchdb][:install_path]})
  EOH
  not_if "/usr/bin/test -d #{node[:couchdb][:install_path]}"
end

runit_service "couchdb"
