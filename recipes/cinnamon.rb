#
# Cookbook:: chef.cookbook.gui
# Recipe:: cinnamon
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'apt'

package 'install cinnamon from package' do
  package_name node['chef.cookbook.gui']['cinnamon']['package_name']
end

service 'lightdm' do
  action [:enable, :start]
  subscribes :start, 'package[install cinnamon from package]', :delayed
end