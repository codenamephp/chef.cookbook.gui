# frozen_string_literal: true

property :schema, String, required: true, description: 'The schema to interact with. Also check the constants for it.'
property :path, String, description: 'A path that will be appended with : to the schema'
property :key, String, required: true, description: 'The key to interact with within the schema. Also check the constants for it.'
property :value, String, required: true, description: 'The value to set. Only required for set action'
property :users, Array, required: true, description: 'The users to set the settings for as array of usernames'

action :set do
  user_loop(new_resource.users)
end

action_class do
  def build_set_command(schema, path, key, value, user)
    schema += ":#{path}" if path
    "sudo -u #{user} dbus-launch gsettings set #{schema} #{key} \"#{value}\""
  end
end

action_class do
  def user_loop(users)
    users.each do |user|
      execute 'Set gsettings value' do
        command build_set_command(new_resource.schema, new_resource.path, new_resource.key, new_resource.value, user)
      end
    end
  end
end
