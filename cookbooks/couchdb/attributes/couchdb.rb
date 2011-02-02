

set[:couchdb][:version] = "1.0.2"
set[:couchdb][:machine] = "64bit"
set[:couchdb][:repo_url] = "https://s3.amazonaws.com/verdeeco.builds"
set[:couchdb][:install_path] = "/opt/couchdb"
set[:couchdb][:data_path] = "/srv/couchdb"
set[:couchdb][:home_dir] = "/home/couchdb"

set[:couchdb][:bind_address] = "0.0.0.0"
set[:couchdb][:port] = "5984"

set[:couchdb][:erlang][:name] = "couchdb"
set[:couchdb][:erlang][:cookie] = "cd62cs92cs73s0fjg8owob8b"
set[:couchdb][:erlang][:version] = "R14B01"
set[:couchdb][:erlang][:name_type] = "name"