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
              def set(definition)
                @definitions[definition.name] = definition unless definition.empty?
              end
            end
          end
        end
      end
    end
  end
end
