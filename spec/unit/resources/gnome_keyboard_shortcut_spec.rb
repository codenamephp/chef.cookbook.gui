# frozen_string_literal: true

require 'spec_helper'

describe 'codenamephp_gui_gnome_keyboard_shortcut' do
  step_into :codenamephp_gui_gnome_keyboard_shortcut

  def settings_expectation(chef_run, name, index, key, value)
    expect(chef_run).to set_codenamephp_gui_gnome_gsettings("Set new custom binding #{key} for #{name}").with(
      schema: CodenamePHP::Gui::Helper::GNOME::GSettings::SCHEMA_PLUGINS_MEDIA_KEYS,
      path: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/",
      key: key,
      value: value
    )
  end

  context 'Add with minimal attributes and no existing binding' do
    stubs_for_provider('codenamephp_gui_gnome_keyboard_shortcut[Add shortcut]') do |provider|
      allow(provider).to receive_shell_out('gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings').and_return('[]')
    end

    recipe do
      codenamephp_gui_gnome_keyboard_shortcut 'Add shortcut' do
        command 'some-command'
        binding 'some keys'
      end
    end

    it 'will set the binding array' do
      expect(chef_run).to set_codenamephp_gui_gnome_gsettings('Set new custom bindings array')
    end

    it 'will set the new binding' do
      settings_expectation(chef_run, 'Add shortcut', 0, 'name', 'Add shortcut')
      settings_expectation(chef_run, 'Add shortcut', 0, 'binding', 'some keys')
      settings_expectation(chef_run, 'Add shortcut', 0, 'command', 'some-command')
    end
  end

  context 'Add with minimal attributes and empty bindings' do
    stubs_for_provider('codenamephp_gui_gnome_keyboard_shortcut[Add shortcut]') do |provider|
      allow(provider).to receive_shell_out('gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings').and_return('@as []')
    end

    recipe do
      codenamephp_gui_gnome_keyboard_shortcut 'Add shortcut' do
        command 'some-command'
        binding 'some keys'
      end
    end

    it 'will set the binding array' do
      expect(chef_run).to set_codenamephp_gui_gnome_gsettings('Set new custom bindings array')
    end

    it 'will set the new binding' do
      settings_expectation(chef_run, 'Add shortcut', 0, 'name', 'Add shortcut')
      settings_expectation(chef_run, 'Add shortcut', 0, 'binding', 'some keys')
      settings_expectation(chef_run, 'Add shortcut', 0, 'command', 'some-command')
    end
  end

  context 'Add with shortcut_name and existing binding' do
    stubs_for_provider('codenamephp_gui_gnome_keyboard_shortcut[Replace shortcut]') do |provider|
      allow(provider).to receive_shell_out('gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings').and_return(
        "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
      )
      allow(provider).to receive_shell_out('get gsettings list-recursively :/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/').and_return(<<~SETTINGS
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding binding '<Primary><Alt>t'
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding command 'gnome-terminal --maximize'
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding name 'Terminal'
      SETTINGS
                                                                                                                                                                  )
      allow(provider).to receive_shell_out('get gsettings list-recursively :/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/').and_return(<<~SETTINGS
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding binding 'should'
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding command 'be'
        org.gnome.settings-daemon.plugins.media-keys.custom-keybinding name 'replaced'
      SETTINGS
                                                                                                                                                                  )
    end

    recipe do
      codenamephp_gui_gnome_keyboard_shortcut 'Replace shortcut' do
        shortcut_name 'replaced'
        command 'some-command'
        binding 'some keys'
      end
    end

    it 'will set the binding array' do
      expect(chef_run).to set_codenamephp_gui_gnome_gsettings('Set new custom bindings array')
    end

    it 'will set the new binding' do
      settings_expectation(chef_run, 'Terminal', 0, 'name', 'Terminal')
      settings_expectation(chef_run, 'Terminal', 0, 'binding', '<Primary><Alt>t')
      settings_expectation(chef_run, 'Terminal', 0, 'command', 'gnome-terminal --maximize')

      settings_expectation(chef_run, 'replaced', 1, 'name', 'replaced')
      settings_expectation(chef_run, 'replaced', 1, 'binding', 'some keys')
      settings_expectation(chef_run, 'replaced', 1, 'command', 'some-command')
    end
  end
end
