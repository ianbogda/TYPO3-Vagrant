#
# Cookbook Name:: typo3
# Recipe:: default
#

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php::multi"

node.set['typo3']['source']['dir'] = "/var/www/src"
node.set['typo3']['db']['password'] = "joh316"

# create a mysql database
execute "mysql-install-typo3-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
  action :nothing
end

execute "disable-default-site" do
	command "sudo a2dissite default"
end

web_app "typo3" do
	template "typo3.conf.erb"
	docroot "#{node['typo3']['dir']}"
end

include_recipe "typo3::dev"