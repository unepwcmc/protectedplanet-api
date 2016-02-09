require 'active_record'

$environment = (ENV["API_ENV"] || ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development")
db_config = YAML.load_file("config/database.yml")[$environment]

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

