$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'yaml'
require 'erb'
require 'logger'
require 'active_record'
require 'config/environment'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += ["test", "."]
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test]

db_config = ERB.new(File.read("config/database.yml")).result
database_configuration = YAML.load(db_config)

namespace :db do
  task :load_config do
    ActiveRecord::Base.configurations = database_configuration
    ActiveRecord::Tasks::DatabaseTasks.database_configuration = database_configuration
    ActiveRecord::Tasks::DatabaseTasks.db_dir = "db"
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ["db/migrate"]
    ActiveRecord::Tasks::DatabaseTasks.root = File.dirname(__FILE__)
    ActiveRecord::Tasks::DatabaseTasks.env = $environment
  end
end

task :environment do
  Rake::Task["db:load_config"].invoke
end

load "active_record/railties/databases.rake"

# Load custom tasks from `lib/tasks` if you have any defined
Dir.glob('lib/tasks/*.rake').each { |r| import r }
