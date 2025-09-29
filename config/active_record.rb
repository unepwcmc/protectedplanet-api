require 'active_record'
require 'erb'

# Process ERB templates in database.yml
database_config = ERB.new(File.read("config/database.yml")).result
db_config = YAML.load(database_config)[$environment]

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

