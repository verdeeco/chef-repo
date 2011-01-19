
# various dependencies most if not all machines will need

%w(iotop sysstat emacs-snapshot-nox vim).each do pkg
  package pkg
end

%w(git build-essential).each do recipe
  include_recipe recipe
end