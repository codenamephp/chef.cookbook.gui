# Checks if we are inside a Continuous Integration machine.
#
# @return [Boolean] whether we are inside a CI.
# @example
#   ci? #=> false
def ci?
  ENV['ENV'] == 'ci'
end

def use_dokken?
  ENV['USE_DOKKEN'] || ci?
end

task default: %w[style unit integration]

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks using rubocop'
  RuboCop::RakeTask.new(:ruby) do |task|
    task.options = ['-a']
  end

  require 'foodcritic'
  desc 'Run Chef style checks using foodcritic'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: %w[style:chef style:ruby]

namespace :unit do
  require 'rspec/core/rake_task'
  desc 'Run unit tests with rspec'
  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.rspec_opts = '--color --format progress'
    t.pattern = 'spec/unit/**{,/*/**}/*_spec.rb'
  end
end

desc 'Run all unit tests'
task unit: %w[unit:rspec]

desc 'Run Test Kitchen integration tests'
namespace :integration do
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    return instances if regexp.nil? || regexp == 'all'
    instances.get_all(Regexp.new(regexp))
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }
    kitchen_instances(regexp, config).each { |i| i.send(action) }
  end

  desc 'Run Test Kitchen integration tests using vagrant'
  task :vagrant, %i[regexp action] do |_t, args|
    run_kitchen(args.action, args.regexp)
  end

  desc 'Run Test Kitchen integration tests using dokken'
  task :dokken, %i[regexp action] do |_t, args|
    run_kitchen(args.action, args.regexp, local_config: '.kitchen.dokken.yml')
  end
end

desc 'Run Test Kitchen integration tests'
task :integration, %i[regexp action] => ci? || use_dokken? ? %w[integration:dokken] : %w[integration:vagrant]

namespace :release do
  desc 'Tag and release to supermarket with stove'
  task :stove do
    sh 'chef exec stove --username codenamephp --key ./codenamephp.pem'
  end

  desc 'Upload to chef server with berks'
  task :berksUpload do
    sh 'chef exec berks upload'
  end
end

desc 'Run the release cycle'
task release: %w[release:stove release:berksUpload]
