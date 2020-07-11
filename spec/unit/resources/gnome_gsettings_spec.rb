# frozen_string_literal: true

require 'spec_helper'

describe 'codenamephp_gui_gnome_gsettings' do
  step_into :codenamephp_gui_gnome_gsettings

  context 'Add with minimal attributes' do
    recipe do
      codenamephp_gui_gnome_gsettings 'Set value' do
        schema 'my.schema'
        key 'my-key'
        value 'myValue'
        users ['test']
      end
    end

    it 'will execute the command' do
      expect(chef_run).to run_execute('Set gsettings value').with(
        command: 'sudo -u test dbus-launch gsettings set my.schema my-key "myValue"'
      )
    end
  end

  context 'Add with path attribute' do
    recipe do
      codenamephp_gui_gnome_gsettings 'Set value' do
        schema 'my.schema'
        path 'my.path'
        key 'my-key'
        value 'myValue'
        users ['test']
      end
    end

    it 'will execute the command' do
      expect(chef_run).to run_execute('Set gsettings value').with(
        command: 'sudo -u test dbus-launch gsettings set my.schema:my.path my-key "myValue"'
      )
    end
  end
end
