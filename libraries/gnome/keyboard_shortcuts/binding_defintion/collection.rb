# frozen_string_literal: true

module CodenamePHP
  module Gui
    module Helper
      module Gnome
        module KeyboardShortcuts
          module BindingDefinition
            # Simple Collection class for BindingDefinition instances
            # Makes sure each definition is set with its name as key
            # So replacing will work as expected
            class Collection
              include Enumerable

              Hash @definitions

              # Initializes the definitions as empty hash
              def initialize
                @definitions = {}
              end

              # Implementatioin of each for the Enumerable Mixin that just
              # delegates the given block to the definitions has .each() method
              #
              # @param [Block] block to pass to each
              #
              # @return [BindingDefinition] the definition for the current iteration
              def each(&block)
                @definitions.each(&block)
              end

              # Just delegates to the defintions hash size method
              #
              # @return [Integer] the size of the definitions hash
              def size
                @definitions.size
              end

              # Sets a definition to the hash using its name as key. That means
              # that if a definition with that name already exists it will be replaced
              #
              # @returns [self] Fluent interface
              def set(definition)
                @definitions[definition.name] = definition unless definition.empty?
                self
              end

              # Builds the paths that is used for gsettings for the current bindings
              #
              # @return [Array] The paths as string array
              #
              # @example
              # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/
              def paths
                Array.new(size) do |index|
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
                end
              end

              # Builds the paths as string that resembles and array of paths by joining the result of self.paths with "','"
              # and surrounding it with ['']
              #
              # @return [String] The paths as string resembling an array
              #
              # @example
              # ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']
              def paths_s
                "['#{paths.join("','")}']"
              end
            end
          end
        end
      end
    end
  end
end
