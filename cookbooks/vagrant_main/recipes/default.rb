require_recipe "apt"

# Optional packages that I like to have installed
%w{vim man-db git-core}.each do | pkg |
  package pkg
end

# Run apt-get update before the chef convergence stage
r = execute "apt-get update" do
  user "root"
  command "apt-get update"
  action :nothing
end
r.run_action(:run)

require_recipe "openssl"
require_recipe "apache2"
require_recipe "mysql"
require_recipe "php"

execute "disable-default-site" do
  command "sudo a2dissite default"
  notifies :reload, resources(:service => "apache2"), :delayed
end

web_app "project" do
  template "project.conf.erb"
  notifies :reload, resources(:service => "apache2"), :delayed
end
