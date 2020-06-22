# frozen_string_literal: true

describe 'codenamephp_gui_gnome' do
  step_into :codenamephp_gui_gnome

  context 'Install when all attributes are default' do
    recipe do
      codenamephp_gui_gnome 'install gnome'
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs gnome-core from package' do
      expect(chef_run).to install_package('install gnome from package').with(package_name: 'gnome-core')
    end
  end

  context 'Install with custom package name' do
    recipe do
      codenamephp_gui_gnome 'install gnome' do
        package_name 'some package'
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs gnome-core from package' do
      expect(chef_run).to install_package('install gnome from package').with(package_name: 'some package')
    end
  end

  context 'Uninstall with default attributes' do
    recipe do
      codenamephp_gui_gnome 'install gnome' do
        action :uninstall
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs gnome-core from package' do
      expect(chef_run).to remove_package('uninstall gnome from package').with(package_name: 'gnome-core')
    end
  end

  context 'Uninstall with default attributes' do
    recipe do
      codenamephp_gui_gnome 'install gnome' do
        package_name 'some package'
        action :uninstall
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs gnome-core from package' do
      expect(chef_run).to remove_package('uninstall gnome from package').with(package_name: 'some package')
    end
  end
end
