#
# Cookbook:: codenamephp_gui
# Recipe:: xfce
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe '::reboot'

package 'install xfce from package' do
  package_name node['codenamephp_gui']['xfce']['package_name']
  notifies :request_reboot, 'reboot[reboot]', :immediately # disabled for now, see https://github.com/codenamephp/chef.cookbook.gui/issues/4
end

service 'lightdm' do
  action %i[enable start]
  subscribes :start, 'package[install xfce from package]', :delayed
end

remote_directory '/etc/skel/xfce4' do
  action :create_if_missing
  source 'xfce4'
  owner 'root'
  group 'root'
  mode '0755'
  purge true
end

node['etc']['passwd'].each do |user, data|
  next unless data['uid'].to_i >= 1000 && File.directory?(data['dir'])

  directory "#{data['dir']}/.config" do
    owner user
    group data['gid']
    mode '0755'
  end

  remote_directory "#{data['dir']}/.config/xfce4" do
    action :create_if_missing
    source 'xfce4'
    owner user
    group data['gid']
    mode '0755'
  end
end
