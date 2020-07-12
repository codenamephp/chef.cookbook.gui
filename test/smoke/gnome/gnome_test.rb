# frozen_string_literal: true

# Inspec test for recipe codenamephp_gui::gnome

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'gnome-1.0' do
  title 'Install gnome Gui'
  desc 'Install gnome Gui with a minimal install'

  describe package('gnome-core') do
    it { should be_installed }
  end

  describe command('sudo -u test gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings') do
    its('stdout.strip') { should eq "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']" }
  end

  describe command('sudo -u test gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/') do
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding binding '<Super><Alt>t'")) }
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding command 'gnome-terminal --maximize'")) }
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding name 'Terminal'")) }
  end

  describe command('sudo -u test gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/') do
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding binding '<Super><Alt>w'")) }
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding command 'echo Whatever")) }
    its('stdout') { should match(Regexp.new("org.gnome.settings-daemon.plugins.media-keys.custom-keybinding name 'Whatever'")) }
  end
end
