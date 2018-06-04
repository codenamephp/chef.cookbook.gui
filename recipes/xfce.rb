#
# Cookbook:: codenamephp_gui
# Recipe:: xfce
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'apt'

package 'install xfce from package' do
  package_name node['codenamephp_gui']['xfce']['package_name']
end

service 'lightdm' do
  action %i[enable start]
  subscribes :start, 'package[install xfce from package]', :delayed
end
