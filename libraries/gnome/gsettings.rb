# frozen_string_literal: true

module CodenamePHP
  module Gui
    module Helper
      module Gnome
        module GSettings
          SCHEMA_DESKTOP_SESSION = 'org.gnome.desktop.session'
          SCHEMA_PLUGINS_MEDIA_KEYS = 'org.gnome.settings-daemon.plugins.media-keys'
          SCHEMA_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDING = "#{SCHEMA_PLUGINS_MEDIA_KEYS}.custom-keybinding"

          KEY_DESKTOP_SESSION_IDLE_DELAY = 'idle-delay'
          KEY_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDINGS = 'custom-keybindings'
        end
      end
    end
  end
end
