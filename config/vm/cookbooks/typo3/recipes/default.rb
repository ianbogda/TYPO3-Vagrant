#
# Cookbook Name:: typo3
# Recipe:: default
#

# create a mysql database
execute "mysql-install-typo3-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
  action :nothing
end

execute "disable-default-site" do
	command "sudo a2dissite default"
end

node.set['typo3']['servername'] = "localhost"

web_app "typo3" do
	template "typo3.conf.erb"
	docroot "#{node['typo3']['dir']}"
	server_name "#{node['typo3']['servername']}"
end

include_recipe "typo3::dev"