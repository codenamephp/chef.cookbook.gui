# frozen_string_literal: true

module CodenamePHP
  module Gui
    module Helper
      module Gnome
        module KeyboardShortcuts
          module BindingDefinition
            # Simple factory to create BindingDefinition instances
            class Factory
              # Creates a new definition from a definition string. The string is in the format that is returned by gsettings
              #
              # @param [String] definition_string The definition string to be parsed into a BindingDefinition instance
              #
              # @return [BindingDefintion] The BindingDefinition resulting from the parsed string
              #
              # @example
              #
              # gsettings command: gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/
              # definition_string:
              #
              # org.gnome.settings-daemon.plugins.media-keys.custom-keybinding binding '<Primary><Alt>t'
              # org.gnome.settings-daemon.plugins.media-keys.custom-keybinding command 'gnome-terminal --maximize'
              # org.gnome.settings-daemon.plugins.media-keys.custom-keybinding name 'Terminal'
              #
              def self.from_string(definition_string)
                BindingDefinition.new(definition_string[/name '([^']+)/, 1], definition_string[/command '([^']+)/, 1], definition_string[/binding '([^']+)/, 1])
              end

              # Creates a new definition from a chef new_resource object that must provide the shortcut_name, command and binding properties
              #
              # @param [Object] A new_resource object from chef
              #
              # @return [BindingDefintion] The BindingDefinition resulting from the parsed string
              #
              def self.from_new_resource(new_resource)
                BindingDefinition.new(new_resource.shortcut_name, new_resource.command, new_resource.binding)
              end
            end
          end
        end
      end
    end
  end
end
