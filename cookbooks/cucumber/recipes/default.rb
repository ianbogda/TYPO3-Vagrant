#
# Cookbook Name:: cucumber
# Recipe:: default
#

execute "install-gem" do
 command "gem update --system"
 command "gem install bundler --no-ri --no-rdoc"
end

node.set['cucumber']['dir'] = "/var/www"

git "#{node['cucumber']['dir']}" do
	repository "git clone git://github.com/typo3-ci/uat.git"
	reference "master"
	enable_submodules true
	action :sync
end

execute "install-cucumber" do
	cwd #{node['cucumber']['dir']}
	command "bundle install"
	command "bundle exec cucumber CUCUMBER_HOST=http://localhost:8080/"
end