# frozen_string_literal: true

property :package_name, String, default: 'xfce4', description: 'The package name that is used to install xfce4'
property :lightdm, [true, false], default: true, description: 'Flag if the lightdm display manager should be managed'

action :install do
  package 'install xfce4 from package' do
    package_name new_resource.package_name
  end

  service 'lightdm' do
    action %i[enable start]
    subscribes :start, 'package[install xfce4 from package]', :delayed
    only_if { new_resource.lightdm }
  end
end

action :uninstall do
  package 'uninstall xfce4 from package' do
    package_name new_resource.package_name
    action :remove
  end

  package 'uninstall lightdm' do
    package_name 'lightdm'
    action :remove
    only_if { new_resource.lightdm }
  end
end
