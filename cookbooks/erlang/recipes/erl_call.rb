
# install the erl_call binary

cookbook_file "/usr/local/bin/erl_call" do
  source "erl_call"
  owner "root"
  group "root"
  mode "0755"
end