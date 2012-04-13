name "typo3"
description "TYPO3 setup"

run_list(
  "recipe[vagrant_main]",
  "recipe[apache2]",
  "recipe[mysql::server]",
  "recipe[php::multi]"
)

override_attributes({
	"typo3" => {
		"source" => {
			"dir" => "/var/www/src"
		},
		"db" => {
			"password" => "joh316"
		}
	},
	"mysql" => {
		"server_root_password"   => "joh316",
		"server_debian_password" => "joh316",
		"server_repl_password"   => "joh316"
	}
})
