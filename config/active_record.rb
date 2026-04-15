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
env_name = ENV.fetch('RACK_ENV')

ActiveRecord.default_timezone = :utc
ActiveRecord::Base.configurations = ActiveRecord::DatabaseConfigurations.new(database_settings)
ActiveRecord::Base.establish_connection(env_name.to_sym)
