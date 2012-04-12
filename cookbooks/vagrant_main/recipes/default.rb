#
# Cookbook Name:: Vagrant_main
# Recipe:: default	
#

require_recipe "apt"
require_recipe "git"

#
# Setup TYPO3
#
require_recipe "typo3"

#
# Setup Cucumber
#
require_recipe "cucumber"