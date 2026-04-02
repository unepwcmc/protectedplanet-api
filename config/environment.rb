APP_ROOT = File.expand_path('..', __dir__) unless defined?(APP_ROOT)
$LOAD_PATH.unshift(APP_ROOT) unless $LOAD_PATH.include?(APP_ROOT)

require 'dotenv'
Dotenv.load

unless defined?(APP_ENV_INITIALIZED)
  api_rack_env = ENV.fetch('API_RACK_ENV') do
    raise KeyError, 'API_RACK_ENV is required (e.g. development/test/production) for protectedplanet-api'
  end
  ENV['RACK_ENV'] = api_rack_env
  APP_ENV = api_rack_env

  APP_ENV_INITIALIZED = true
end

require 'logger'
require 'bigdecimal'

# Sinatra
require 'rack/csrf'
require 'rack/cors'
require 'sinatra'

# Grape
require 'grape'
require 'action_view'
require 'kaminari'
require 'kaminari/activerecord'

require 'appsignal'
require 'active_support'

# Markdown rendering
require 'kramdown'
Tilt.prefer Tilt::KramdownTemplate

# Notifications
require 'pony'

# Configuration files
require 'config/secrets'
require 'config/pony'
require 'config/active_record'

# Models
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }
