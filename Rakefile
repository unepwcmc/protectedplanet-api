$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'yaml'
require 'erb'
require 'logger'
require 'config/environment'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += ["test", "."]
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test]

# Load custom tasks from `lib/tasks` if you have any defined
Dir.glob('lib/tasks/*.rake').each { |r| import r }
