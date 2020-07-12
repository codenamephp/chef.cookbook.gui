module CodenamePHP
  module Gui
    module Helper
      module Gnome
        module KeyboardShortcuts
          class BindingDefintion
            attr_reader :name, :command, :binding
            
            String @name
            String @command
            String @binding

            def initialize(name, command, binding)
              @name = name.strip
              @command = command.strip
              @binding = binding.strip
            end

            def empty?
              @name.empty? && @command.empty? && @binding.empty?
            end

            def valid?
              !@name.empty && !@command.empty? && !@binding.empty?
            end
          end
        end
      end
    end
  end
end