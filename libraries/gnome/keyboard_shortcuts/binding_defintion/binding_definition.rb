# frozen_string_literal: true

module CodenamePHP
  module Gui
    module Helper
      module Gnome
        module KeyboardShortcuts
          module BindingDefinition
            # A simple binding defintion entity
            #
            class BindingDefinition
              attr_reader :name, :command, :binding

              String @name
              String @command
              String @binding

              # Sets the given properties while stripping them
              #
              # @param [String] name The name of binding, e.g. "Terminal"
              # @param [String] command The command to be executed, e.g. "gnome-terminal --maximize"
              # @param [String] binding The key binding, e.g. <Super><Alt>t
              #
              def initialize(name, command, binding)
                @name = name.strip
                @command = command.strip
                @binding = binding.strip
              end

              # Checks if the binding is empty
              #
              # @returns [true] if name, command and binding are empty
              #
              def empty?
                @name.empty? && @command.empty? && @binding.empty?
              end

              # Checks if the binding is valid
              #
              # @returns [true] if either of name, command or binding are empty
              #
              def valid?
                !@name.empty && !@command.empty? && !@binding.empty?
              end
            end
          end
        end
      end
    end
  end
end
