#
# Cookbook Name:: typo3
# Recipe:: default
#
# TODO:
#	Symlink
#	TEST - Create Db
#	TEST - ENABLE_INSTALL_TOOL
#	TEST - SOURCE DIR
#	TEST - Localconf template
#	Installer scripts
#

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "apache2::mod_php5"


if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

node.set['typo3']['source']['dir'] = "/var/www/src"
node.set['typo3']['db']['password'] = secure_password

remote_file "#{Chef::Config[:file_cache_path]}/typo3-#{node['typo3']['version']}.tar.gz" do
  source "http://downloads.sourceforge.net/project/typo3/TYPO3%20Source%20and%20Dummy/TYPO3%20#{node['typo3']['version']}/typo3_src-#{node['typo3']['version']}.tar.gz"
  mode "0644"
end

directory "#{node['typo3']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

directory "#{node['typo3']['source']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-typo3" do
 cwd node['typo3']['source']['dir']
 command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/typo3-#{node['typo3']['version']}.tar.gz"
end

execute "mysql-install-typo3-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
  action :nothing
end

template "#{node['mysql']['conf_dir']}/wp-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node['typo3']['db']['user'],
    :password => node['typo3']['db']['password'],
    :database => node['typo3']['db']['database']
  )
  notifies :run, "execute[mysql-install-typo3-privileges]", :immediately
end

execute "create #{node['typo3']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['typo3']['db']['database']}"
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

file "#{node['typo3']['dir']}/typo3conf/ENABLE_INSTALL_TOOL" do
	mode "0655"
	action :create
end

log "Navigate to 'http://#{server_fqdn}/typo3/install/index.php' to complete TYPO3 installation" do
  action :nothing
end

#template "#{node['typ3']['dir']}/typo3conf/localconf.php" do
#  source "localconf.php.erb"
#  owner "root"
#  group "root"
#  mode "0644"
#  variables(
#    :database        => node['typo3']['db']['database'],
#    :user            => node['typo3']['db']['user'],
#    :password        => node['typo3']['db']['password']
#  )
#  notifies :write, "log[Navigate to 'http://#{server_fqdn}/typo3/install/index.php' to complete wordpress installation]"
#end

execute "disable-default-site" do
  command "sudo a2dissite default"
end

web_app "typo3" do
  template "typo3.conf.erb"
  docroot "#{node['typo3']['dir']}"
  server_name server_fqdn
end