APP_ROOT = File.expand_path('..', __dir__) unless defined?(APP_ROOT)
$LOAD_PATH.unshift(APP_ROOT) unless $LOAD_PATH.include?(APP_ROOT)

require 'bundler/setup'

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
require 'yaml'
require 'active_support'
require 'active_support/core_ext/hash'

# Sinatra
require 'rack/csrf'
require 'rack/cors'
require 'sinatra'

# Load secrets, mail, and DB before Grape (predictable load order; secrets need APP_ENV).
require 'config/secrets'
require 'pony'
require 'config/pony'
require 'config/active_record'

# Grape
require 'grape'
require 'action_view'
require 'kaminari'
require 'kaminari/activerecord'

require 'appsignal'

# Markdown rendering
require 'kramdown'
Tilt.prefer Tilt::KramdownTemplate

# Models
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }
