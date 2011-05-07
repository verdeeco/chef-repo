
include_recipe "couchdb"
include_recipe "runit"

package "openjdk-6-jdk"

filename = "couchdb-lucene-#{node[:couchdb_lucene][:version]}-dist.tar.gz"

remote_file "/tmp/#{filename}" do
  source "#{node[:couchdb_lucene][:repo_url]}/#{filename}"
  mode 0644
  owner "couchdb"
  group "couchdb"
  not_if "/usr/bin/test -d #{node[:couchdb_lucene][:install_path]}"
end

bash "install couchdb-lucene" do
  user "root"
  cwd "/opt"
  code <<-EOH
  (mkdir #{node[:couchdb_lucene][:install_path]})
  (tar zxf /tmp/#{filename} -C #{node[:couchdb_lucene][:install_path]})
  (rm -f /tmp/#{filename})
  (chown -R couchdb:couchdb #{node[:couchdb_lucene][:install_path]})
  EOH
  not_if "/usr/bin/test -d #{node[:couchdb_lucene][:install_path]}"
end

runit_service "couchdb-lucene"

## configure couchdb for couchdb-lucene

erl_call "dump couchdb os_process_timeout" do
  code "couch_config:set(\"couchdb\", \"os_process_timeout\", \"60000\").\r"
  cookie node[:couchdb][:erlang][:cookie]
  name_type "name"
  node_name "#{node[:couchdb][:erlang][:name]}@#{node[:fqdn]}"
  not_if do (`cat #{node[:couchdb][:install_path]}/etc/local.ini`.include?("os_process_timeout")) end
end

erl_call "set fti external" do
  code "couch_config:set(\"external\", \"fti\", \"/usr/bin/python #{node[:couchdb_lucene][:install_path]}/couchdb-lucene-#{node[:couchdb_lucene][:version]}/tools/couchdb-external-hook.py\").\r"
  cookie node[:couchdb][:erlang][:cookie]
  name_type "name"
  node_name "#{node[:couchdb][:erlang][:name]}@#{node[:fqdn]}"
  not_if do (`cat #{node[:couchdb][:install_path]}/etc/local.ini`.include?("external")) end
end


fti_code =<<EOFTI
couch_config:set("httpd_db_handlers", "_fti", "{couch_httpd_external, handle_external_req, <<"fti">>}").
EOFTI
erl_call "set _fti httpd_db_handlers" do
#  code "couch_config:set(\"httpd_db_handlers\", \"_fti\", \"{couch_httpd_external, handle_external_req, <<\"\"fti\"\">>}\").\r"
  code fti_code
  cookie node[:couchdb][:erlang][:cookie]
  name_type "name"
  node_name "#{node[:couchdb][:erlang][:name]}@#{node[:fqdn]}"
  not_if do (`cat #{node[:couchdb][:install_path]}/etc/local.ini`.include?("_fti")) end
end
