Vagrant::Config.run do |config|
	config.vm.box     = "oneiric32_base"
	config.vm.box_url = "http://files.travis-ci.org/boxes/bases/oneiric32_base.box"

	# IP-address to connect to
	config.vm.network :hostonly, "10.11.12.13"

	# computers to access the VM, whereas host only networking does not.
	config.vm.forward_port 80, 8080
	config.vm.forward_port 3306, 13306

	# Share an additional folder to the guest VM. The first argument is
	# an identifier, the second is the path on the guest to mount the
	# folder, and the third is the path on the host to the actual folder.
	# config.vm.share_folder "v-data", "/vagrant_data", "../data"
	config.vm.share_folder "www", "/var/www/site", "./www"

	config.vm.provision :chef_solo do |chef|

		chef.cookbooks_path = ["cookbooks"]
	
		# Turn on verbose Chef logging if necessary
		# chef.log_level      = :debug

		# List the recipies you are going to work on/need.
		chef.add_recipe     "build-essential"    
		chef.add_recipe     "travis_build_environment"
		chef.add_recipe     "vagrant_main"

		# You may also specify custom JSON attributes:
		chef.json = { :mysql_password => "" }
	end

end
