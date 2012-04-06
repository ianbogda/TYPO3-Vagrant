require_recipe "apt"

# Optional packages that I like to have installed
%w{vim man-db git-core}.each do | pkg |
  package pkg
end

# Run apt-get update before the chef convergence stage
r = execute "apt-get update" do
  user "root"
  command "apt-get update"
  action :nothing
end
r.run_action(:run)

require_recipe "typo3"