# frozen_string_literal: true

#
# Cookbook:: codenamephp_gui
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'codenamephp_gui_xfce4' do
  step_into :codenamephp_gui_xfce4

  context 'Install when all attributes are default' do
    let(:lightdmService) { chef_run.service('lightdm') }

    recipe do
      codenamephp_gui_xfce4 'install xfce4'
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs xfce4-core from package' do
      expect(chef_run).to install_package('install xfce4 from package').with(package_name: 'xfce4-core')
    end

    it 'starts and enables lightdm service' do
      expect(chef_run).to enable_service('lightdm')
      expect(chef_run).to start_service('lightdm')
    end

    it 'subscribes lightdm to start delayed when the package is installed' do
      expect(lightdmService).to subscribe_to('package[install xfce4 from package]').on(:start).delayed
    end
  end

  context 'Install when custom package name was set' do
    recipe do
      codenamephp_gui_xfce4 'install xfce4' do
        package_name 'other package'
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs xfce4-core from package' do
      expect(chef_run).to install_package('install xfce4 from package').with(package_name: 'other package')
    end
  end

  context 'Install when lightdm was set to false' do
    recipe do
      codenamephp_gui_xfce4 'install xfce4' do
        lightdm false
      end
    end

    it 'does not register service' do
      expect(chef_run).to_not subscribe_to('package[install xfce4 from package]').on(:start).delayed
    end
  end

  context 'Uninstall when attributes are default' do
    let(:lightdmService) { chef_run.service('lightdm') }

    recipe do
      codenamephp_gui_xfce4 'uninstall xfce4' do
        action :uninstall
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'uninstalls xfce4-core from package' do
      expect(chef_run).to remove_package('uninstall xfce4 from package').with(package_name: 'xfce4-core')
    end

    it 'uninstalls lightdm from package' do
      expect(chef_run).to remove_package('uninstall lightdm').with(package_name: 'lightdm')
    end
  end

  context 'Uninstall with custom package name was set' do
    recipe do
      codenamephp_gui_xfce4 'uninstall xfce4' do
        action :uninstall
        package_name 'other package'
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs xfce4-core from package' do
      expect(chef_run).to remove_package('uninstall xfce4 from package').with(package_name: 'other package')
    end
  end

  context 'Uninstall when lightdm was set to false' do
    recipe do
      codenamephp_gui_xfce4 'uninstall xfce4' do
        action :uninstall
        lightdm false
      end
    end

    it 'does not remove lightdm package' do
      expect(chef_run).to_not remove_package('uninstall lightdm').with(package_name: 'lightdm')
    end
  end
end
