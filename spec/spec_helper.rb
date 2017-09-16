# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'debian'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '9.1'
end