# frozen_string_literal: true

#
# Cookbook:: codenamephp_gui
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'codenamephp_gui::gnome' do
  context 'When all attributes are default' do
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs cinnamon using resource' do
      expect(chef_run).to install_codenamephp_gui_gnome('install gnome')
    end
  end
end
