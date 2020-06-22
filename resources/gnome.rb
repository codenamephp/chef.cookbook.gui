# frozen_string_literal: true

property :package_name, String, default: 'gnome-core', description: 'The package name that is used to install gnome'

action :install do
  package 'install gnome from package' do
    package_name new_resource.package_name
  end
end

action :uninstall do
  package 'uninstall gnome from package' do
    package_name new_resource.package_name
    action :remove
  end
end
