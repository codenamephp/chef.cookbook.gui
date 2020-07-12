# frozen_string_literal: true

#
# Cookbook:: codenamephp_gui
# Recipe:: gnome
#
# Copyright:: 2017, The Authors, All Rights Reserved.

apt_update 'update' do
  action :update
end

codenamephp_gui_gnome 'install gnome'
