# frozen_string_literal: true

property :schema, String, required: true, description: 'The schema to interact with. Also check the constants for it.'
property :key, String, required: true, description: 'The key to interact with within the schema. Also check the constants for it.'
property :value, String, required: true, description: 'The value to set. Only required for set action'

action :set do
  execute 'Set gsettings value' do
    command build_set_command(new_resource.schema, new_resource.key, new_resource.value)
  end
end

action_class do
  def build_set_command(schema, key, value)
    "gsettings set #{schema} #{key} #{value}"
  end
end
