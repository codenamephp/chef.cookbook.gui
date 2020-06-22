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
end
