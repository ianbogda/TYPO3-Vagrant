#
# Cookbook Name:: cucumber
# Recipe:: default
#

execute "install-gem" do
 command "gem update --system"
 command "gem install bundler --no-ri --no-rdoc"
end

execute "install-cucumber" do
	command "git clone git://github.com/typo3-ci/uat.git"
	command "cd uat"
	command "bundle install"
	command "bundle exec cucumber CUCUMBER_HOST=http://10.11.12.13/"
end