name 'codenamephp_gui'
maintainer 'Bastian Schwarz'
maintainer_email 'bastian@codename-php.de'
license 'Apache-2.0'
description 'Cookbook to install linux guis like cinammon or gnome'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.2.0'
chef_version '>= 13.0' if respond_to?(:chef_version)
issues_url 'https://github.com/codenamephp/chef.cookbook.gui/issues' if respond_to?(:issues_url)
source_url 'https://github.com/codenamephp/chef.cookbook.gui' if respond_to?(:source_url)

supports 'debian', '~>9.1'

depends 'apt'
