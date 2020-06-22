# frozen_string_literal: true

# Inspec test for recipe codenamephp_gui::xfce

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control 'xfce-1.0' do
  title 'Install xfce Gui'
  desc 'Install xfce Gui with a minimal install and make sure lightdm is started and enabled'

  describe package('xfce4') do
    it { should be_installed }
  end

  describe service('lightdm') do
    it { should be_installed }
    it { should be_enabled }
  end
end