#
# Cookbook Name:: typo3
# Recipe:: default
#
# TODO:
#	Symlink
#	- TYPO3 version directory
#	TEST - Localconf template
#	- Introduction package
#	- Documentroot
#	- Move Sources to Source dir?
#		- Symlink

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "apache2::mod_php5"
include_recipe "imagemagick"

node.set['typo3']['source']['dir'] = "/var/www/src"
node.set['typo3']['db']['password'] = secure_password

remote_file "#{Chef::Config[:file_cache_path]}/typo3-#{node['typo3']['version']}.tar.gz" do
	source "http://downloads.sourceforge.net/typo3/introductionpackage-#{node['typo3']['version']}.tar.gz"
	mode "0644"
end

directory "#{node['typo3']['dir']}" do
  owner "root"
  group "root"
  mode "0774"
  action :create
  recursive true
end

directory "#{node['typo3']['source']['dir']}" do
  owner "root"
  group "root"
  mode "0774"
  action :create
  recursive true
end

# TODO: Separate Sources & Config
execute "untar-typo3" do
	command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/typo3-#{node['typo3']['version']}.tar.gz #{node['typo3']['dir']}"
end

#execute "mysql-install-typo3-privileges" do
#  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
#  action :nothing
#end

#template "#{node['mysql']['conf_dir']}/wp-grants.sql" do
#  source "grants.sql.erb"
#  owner "root"
#  group "root"
#  mode "0600"
#  variables(
#    :user     => node['typo3']['db']['user'],
#    :password => node['typo3']['db']['password'],
#    :database => node['typo3']['db']['database']
#  )
#  notifies :run, "execute[mysql-install-typo3-privileges]", :immediately
#end

execute "create #{node['typo3']['db']['database']} database" do
	command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['typo3']['db']['database']}"
end

# TODO
log "Navigate to 'http://#{node['typo3']['hostname']}/typo3/install/index.php' to complete TYPO3 installation" do
	action :nothing
end

template "#{node['typo3']['dir']}/typo3conf/localconf.php" do
	source "localconf.php.erb"
	owner "root"
	group "root"
	mode "0774"
	variables(
		:database => node['typo3']['db']['database'],
		:user     => node['typo3']['db']['user'],
		:password => node['typo3']['db']['password']
	)
end

file "#{node['typo3']['dir']}/typo3conf/ENABLE_INSTALL_TOOL" do
	mode "0644"
	action :create
end

execute "disable-default-site" do
	command "sudo a2dissite default"
end

web_app "typo3" do
	template "typo3.conf.erb"
	docroot "#{node['typo3']['dir']}"
end