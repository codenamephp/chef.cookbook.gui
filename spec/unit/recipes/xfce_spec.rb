#
# Cookbook:: codenamephp_gui
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'codenamephp_gui::xfce' do
  context 'When all attributes are default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['etc']['passwd'] = []
      end.converge(described_recipe)
    end
    let(:lightdmService) { chef_run.service('lightdm') }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes apt cookbook to update sources' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'installs xfce from package' do
      expect(chef_run).to install_package('install xfce from package').with(package_name: 'xfce4')
    end

    it 'starts and enables lightdm service' do
      expect(chef_run).to enable_service('lightdm')
      expect(chef_run).to start_service('lightdm')
    end

    it 'subscribes lightdm to start delayed when the package is installed' do
      expect(lightdmService).to subscribe_to('package[install xfce from package]').on(:start).delayed
    end

    it 'will copy the config to the /etc/skel diretory for all newly created users' do
      expect(chef_run).to create_remote_directory_if_missing('/etc/skel/xfce4')
    end
  end

  context 'When custom package name was set' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['codenamephp_gui']['xfce']['package_name'] = 'other package'
        node.override['etc']['passwd'] = []
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs xfce from package' do
      expect(chef_run).to install_package('install xfce from package').with(package_name: 'other package')
    end
  end

  context 'When users were detected' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.override['etc']['passwd'] = {
          'user1' => { 'dir' => '/home/user1', 'uid' => 1000, 'gid' => 123 },
          'user2' => { 'dir' => '/home/user2', 'uid' => 1001, 'gid' => 456 },
          'user3' => { 'dir' => '/home/user2', 'uid' => 500, 'gid' => 789 }
        }
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'copies the xfce folder to all user configs' do
      expect(chef_run).to create_remote_directory_if_missing('/home/user1/.config/xfce4').with(owner: 'user1', group: 123)
      expect(chef_run).to create_remote_directory_if_missing('/home/user2/.config/xfce4').with(owner: 'user2', group: 456)
      expect(chef_run).to_not create_remote_directory_if_missing('/home/user3/.config/xfce4')
    end
  end
end
