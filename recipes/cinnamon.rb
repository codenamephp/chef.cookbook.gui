# frozen_string_literal: true

#
# Cookbook:: codenamephp_gui
# Recipe:: cinnamon
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'install cinnamon from package' do
  package_name node['codenamephp_gui']['cinnamon']['package_name']
end

service 'lightdm' do
  action %i[enable start]
  subscribes :start, 'package[install cinnamon from package]', :delayed
end
