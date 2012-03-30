Vagrant::Config.run do |config|
 
	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "lucid32"

	# computers to access the VM, whereas host only networking does not.
	config.vm.forward_port 80, 8080
	#config.vm.forward_port "mysql", 3306, 13306

	# Share an additional folder to the guest VM. The first argument is
	# an identifier, the second is the path on the guest to mount the
	# folder, and the third is the path on the host to the actual folder.
	# config.vm.share_folder "v-data", "/vagrant_data", "../data"
	config.vm.share_folder "www", "/vagrant", "./www"

	# Enable provisioning with chef solo, specifying a cookbooks path (relative
	# to this Vagrantfile), and adding some recipes and/or roles.

	config.vm.provision :chef_solo do |chef|

		chef.cookbooks_path = "cookbooks"
		# chef.add_recipe "mysql"
		# chef.add_role "web"
		chef.add_recipe "vagrant_main"

		# You may also specify custom JSON attributes:
		chef.json = { :mysql_password => "foo" }
	end

end
