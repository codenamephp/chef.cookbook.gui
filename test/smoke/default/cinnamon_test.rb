# # encoding: utf-8

# Inspec test for recipe chef.cookbook.gui::cinnamon

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

control "cinnamon-1.0" do
  title "Install Cinnamon Gui"
  desc "Install Cinnamon Gui with a minimal install and make sure lightdm is started and enabled"
  
  describe package('cinnamon-core') do
    it { should be_installed }
  end
  
  describe service('lightdm') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
