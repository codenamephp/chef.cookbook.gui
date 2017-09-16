#
# Cookbook:: chef.cookbook.gui
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef.cookbook.gui::cinnamon' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end
    let(:lightdmService) { chef_run.service('lightdm') }
    
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    
    it 'includes apt cookbook to update sources' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'installs cinnamon-core from package' do
      expect(chef_run).to install_package('install cinnamon from package').with(package_name: 'cinnamon-core')
    end
    
    it 'starts and enables lightdm service' do 
      expect(chef_run).to enable_service('lightdm')
      expect(chef_run).to start_service('lightdm')
    end
    
    it 'subscribes lightdm to start delayed when the package is installed' do
      expect(lightdmService).to subscribe_to('package[install cinnamon from package]').on(:start).delayed
    end
  end
  
  context 'When custom package name was set' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['chef.cookbook.gui']['cinnamon']['package_name'] = 'other package'
      end.converge(described_recipe)
    end
    
    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    
    it 'installs cinnamon-core from package' do
      expect(chef_run).to install_package('install cinnamon from package').with(package_name: 'other package')
    end
  end
end