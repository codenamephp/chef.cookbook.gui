# frozen_string_literal: true

property :shortcut_name, String, name_property: true, description: 'The name of the shortcut. If a shortcut with the name already exists it will be replaced'
property :command, String, required: true, description: 'The command the binding should execute'
property :binding, String, required: true, description: 'The keybinding'

action :set do
  binding_definitions = custom_binding_paths.to_h do |path|
    binding_definition = shell_out("get gsettings list-recursively :#{path}")
    name = binding_definition[/name '([^']+)/, 1]
    [name,
     {
       binding: binding_definition[/binding '([^']+)/, 1],
       command: binding_definition[/command '([^']+)/, 1]
     }]
  end

  binding_definitions[new_resource.shortcut_name] = {
    binding: new_resource.binding,
    command: new_resource.command
  }

  codenamephp_gui_gnome_gsettings 'Set new custom bindings array' do
    schema CodenamePHP::Gui::Helper::GNOME::GSettings::SCHEMA_PLUGINS_MEDIA_KEYS
    key CodenamePHP::Gui::Helper::GNOME::GSettings::KEY_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDINGS
    value build_binding_paths(binding_definitions)
  end

  binding_definitions.each_with_index do |(name, binding_definition), index|
    {
      name: name,
      binding: binding_definition[:binding],
      command: binding_definition[:command]
    }.each do |key, value|
      codenamephp_gui_gnome_gsettings "Set new custom binding #{key} for #{name}" do
        schema CodenamePHP::Gui::Helper::GNOME::GSettings::SCHEMA_PLUGINS_MEDIA_KEYS
        path "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
        key key.to_s
        value value
      end
    end
  end
end

action_class do
  def custom_binding_paths
    schema = CodenamePHP::Gui::Helper::GNOME::GSettings::SCHEMA_PLUGINS_MEDIA_KEYS
    key = CodenamePHP::Gui::Helper::GNOME::GSettings::KEY_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDINGS

    shellout = shell_out("gsettings get #{schema} #{key}")
    log "shell_out: #{shellout}"

    regex = shellout[/\[([^\]]*)/, 1]
    log "regex: #{regex}"

    deleted = regex.delete("'")
    log "deleted: #{deleted}"

    split = deleted.split(',')
    log "split: #{split}"

    final = split || []
    log "final: #{final}"

    final
  end

  def build_binding_paths(binding_definitions)
    paths = Array.new(binding_definitions.size) do |index|
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
    end
    "[#{paths.join("','")}]"
  end
end
