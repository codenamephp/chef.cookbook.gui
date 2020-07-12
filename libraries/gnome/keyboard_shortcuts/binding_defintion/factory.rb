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

              # Creates a new definition collection from a definitions string (the one with the array of what definitions are set).
              # The string is parsed and split into paths and then for each path a block that has to be provided is called with the path as parameter
              # The block is supposed to return a string that can be parsed by self.from_string to which teh string is passed on and the resulting definition
              # is set to the collection
              #
              # The definitions string extracts everything between the brackets, removes the single quotes, splits by ',' and strips the entries
              #
              # @params [String] definitions_string A string returned from gsettings containng all available defintion names (paths)
              # @params [Block] A block that takes a path as argument and returns a definition string that is then parsed by self.from_string
              #
              # @returns [Collection] A collection containing all definitions that match the given defintions string and block
              #
              # @example
              #
              # definitions_string: ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']
              # Block: { |path| do_some_shell_command(path) }
              #
              def self.collection_from_string(definitions_string)
                binding_definitions = Collection.new
                paths = definitions_string[/\[([^\]]*)/, 1]&.delete("'")&.split(',')&.map(&:strip) || []
                paths.each { |path| binding_definitions.set(from_string(yield(path))) }
                binding_definitions
              end
            end
          end
        end
      end
    end
  end
end
