$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'config/environment'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += ["test", "."]
  t.pattern = "test/**/*_test.rb"
end

task :default => [:test]

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end
