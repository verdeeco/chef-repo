group "apps" do
  gid 400
end

user "apps" do
  uid 400
  gid 400
  shell "/bin/bash"
  home "/home/apps"
end