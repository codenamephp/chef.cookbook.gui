# frozen_string_literal: true

property :shortcut_name, String, name_property: true, description: 'The name of the shortcut. If a shortcut with the name already exists it will be replaced'
property :command, String, required: true, description: 'The command the binding should execute'
property :binding, String, required: true, description: 'The keybinding'
property :users, Array, required: true, description: 'The users to set the shortcuts for as array of usernames'

include CodenamePHP::Gui::Helper::Gnome # rubocop:todo Style/MixinUsage

action :set do
  new_resource.users.each do |user|
    binding_definitions = create_binding_defintions(user)

    codenamephp_gui_gnome_gsettings 'Set new custom bindings array' do
      schema GSettings::SCHEMA_PLUGINS_MEDIA_KEYS
      key GSettings::KEY_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDINGS
      value binding_definitions.paths_s
      users [user]
    end

    binding_definitions.each_with_index do |(name, binding_definition), index|
      binding_definition.each do |key, value|
        codenamephp_gui_gnome_gsettings "Set new custom binding #{key} for #{name}" do
          schema GSettings::SCHEMA_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDING
          path "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom#{index}/"
          key key.to_s
          value value
          users [user]
        end
      end
    end
  end
end

action_class do
  def get_definition_string(user, path)
    shell_out("sudo -u #{user} dbus-launch gsettings list-recursively #{GSettings::SCHEMA_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDING}:#{path}").stdout
  end

  def create_binding_defintions(user)
    paths_string = shell_out("sudo -u #{user} gsettings get #{GSettings::SCHEMA_PLUGINS_MEDIA_KEYS} #{GSettings::KEY_PLUGINS_MEDIA_KEYS_CUSTOM_KEYBINDINGS}")&.stdout || ''
    binding_definitions = KeyboardShortcuts::BindingDefinition::Factory.collection_from_string(paths_string) { |path| get_definition_string(user, path) }
    binding_definitions.set(KeyboardShortcuts::BindingDefinition::Factory.from_new_resource(new_resource))
  end
end
