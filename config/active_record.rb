require 'active_record'
require 'erb'

class ActiveRecordConnectionManagement
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end

# Process ERB templates in database.yml
database_config = ERB.new(File.read('config/database.yml')).result
database_settings = YAML.safe_load(database_config, aliases: true)
db_config = database_settings.fetch(APP_ENV)

ActiveRecord.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)

use ActiveRecordConnectionManagement
