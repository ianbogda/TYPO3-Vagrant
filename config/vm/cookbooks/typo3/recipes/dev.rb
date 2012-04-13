#
# Cookbook Name:: typo3
# Recipe:: dev
#
# TODO:
#	- Mkdir dirs
#	- Clone Repo
#		- Sources + Dummy Or Introduction
#	- Symlink
#	- Clone Submodules
#	- Localconf template
#	- Introduction package
#

directory "#{node['typo3']['dir']}" do
  owner "root"
  group "root"
  mode "0774"
  action :create
  recursive true
end

directory "#{node['typo3']['source']['dir']}" do
  owner "vagrant"
  group "vagrant"
  mode "0774"
  action :create
  recursive true
end

git "#{node['typo3']['dir']}" do
	repository "git://github.com/ctrabold/TYPO3v4-Core.git"
	reference "master"
	enable_submodules true
	action :sync
end

execute "symlink-sources" do
	command "ln -s  #{node['typo3']['dir']}/typo3_src-4.6.7"
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
