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

task default: %w[style unit integration documentation]

namespace :git do
  desc 'Setting up git for pushing'
  task :setup do
    sh 'git config --local user.name "Travis CI"'
    sh 'git config --local user.email "travis@codename-php.de"'
    sh 'git remote set-url --push origin "https://' + ENV['GH_TOKEN'].to_s + '@github.com/codenamephp/chef.cookbook.gui.git"'
  end
end

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
  def run_kitchen(action, regexp, concurrency, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }

    call_threaded(kitchen_instances(regexp, config), action, concurrency)
  end

  # Calls a method on a list of objects in concurrent threads.
  #
  # @param objects [Array] list of objects.
  # @param method_name [#to_s] method to call on the objects.
  # @param concurrency [Integer] number of objects to call the method on concurrently.
  # @return void
  def call_threaded(objects, method_name, concurrency)
    puts "method_name: #{method_name}, concurrency: #{concurrency}"
    threads = []
    raise 'concurrency must be > 0' if concurrency < 1
    objects.each do |obj|
      sleep 3 until threads.map(&:alive?).count(true) < concurrency
      threads << Thread.new { obj.method(method_name).call }
    end
    threads.map(&:join)
  end

  desc 'Run Test Kitchen integration tests using vagrant'
  task :vagrant, [:regexp, :action, :concurrency] do |_t, args|
    args.with_defaults(regexp: 'all', action: 'test', concurrency: 4)
    run_kitchen(args.action, args.regexp, args.concurrency.to_i)
  end

  desc 'Run Test Kitchen integration tests using dokken'
  task :dokken, [:regexp, :action, :concurrency] do |_t, args|
    args.with_defaults(regexp: 'all', action: 'test', concurrency: 4)
    run_kitchen(args.action, args.regexp, args.concurrency.to_i, local_config: '.kitchen.dokken.yml')
  end
end

desc 'Run Test Kitchen integration tests'
task :integration, %i[regexp action concurrency] => ci? || use_dokken? ? %w[integration:dokken] : %w[integration:vagrant]

namespace :documentation do
  desc 'Generate changelog from current commit message'
  task changelog_commit: ['git:setup'] do
    match = Regexp.new('\[RELEASE\s([\d\.]+)\]').match(ENV['TRAVIS_COMMIT_MESSAGE'])
    unless match.nil?
      sh 'github_changelog_generator --future-release ' + match[1].to_s
      sh 'git status'
      sh 'git add CHANGELOG.md && git commit --allow-empty -m"[skip ci] Updated changelog" && git push origin ' + ENV['TRAVIS_BRANCH']
    end
  end
end
desc 'Run the documentation cycle'
task documentation: %w[documentation:changelog_commit]

namespace :release do
  desc 'Tag and release to supermarket with stove'
  task stove: ['git:setup'] do
    sh 'chef exec stove --username codenamephp --key ./codenamephp.pem'
  end

  desc 'Upload to chef server with berks'
  task :berksUpload do
    sh 'chef exec berks upload'
  end
end

desc 'Run the release cycle'
task release: %w[release:stove release:berksUpload]
