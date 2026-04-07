require 'active_record'
# Must load the gem entry (not only postgis_adapter.rb) so AR 8 registers the "postgis" adapter name.
require 'activerecord-postgis-adapter'
require 'erb'

class ActiveRecordConnectionManagement
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  ensure
    ActiveRecord::Base.connection_handler.clear_active_connections!(:all)
  end
end

# Process ERB templates in database.yml
database_config = ERB.new(File.read('config/database.yml')).result
database_settings = YAML.safe_load(database_config, aliases: true)
db_config = database_settings.fetch(API_APP_ENV)

ActiveRecord.default_timezone = :utc
ActiveRecord::Base.establish_connection(db_config)
