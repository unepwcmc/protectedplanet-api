$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'yaml'
require 'erb'
require 'logger'
require 'rake/testtask'

# Rake tasks in lib/tasks use `=> :environment` (Rails convention). This app is not Rails,
# so we define the task to load ActiveRecord and models.
task :environment do
  require_relative 'config/environment'
end

# Force test env even if shell exports RACK_ENV=development.
task :set_test_env do
  ENV['RACK_ENV'] = 'test'
end

Rake::TestTask.new do |t|
  t.libs += ['test', '.']
  t.pattern = 'test/**/*_test.rb'
end

task test: :set_test_env

task default: [:test]

# Load custom tasks from `lib/tasks` if you have any defined
Dir.glob('lib/tasks/*.rake').each { |r| import r }
