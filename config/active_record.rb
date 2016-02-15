require 'active_record'

db_config = YAML.load_file("config/database.yml")[$environment]

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

