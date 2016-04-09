$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'active_record_migrations'
require 'config/environment'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += ["test", "."]
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test]

ActiveRecordMigrations.configure do |c|
  c.yaml_config = "config/database.yml"
  c.environment = $environment
end
ActiveRecordMigrations.load_tasks

# Load custom tasks from `lib/tasks` if you have any defined
Dir.glob('lib/tasks/*.rake').each { |r| import r }
