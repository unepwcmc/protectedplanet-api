APP_ENV = ENV.fetch("API_ENV", ENV.fetch("RACK_ENV", ENV.fetch("RAILS_ENV", "development")))
ENV["API_ENV"] = ENV["RACK_ENV"] = ENV["RAILS_ENV"] = APP_ENV unless defined?(APP_ENV_INITIALIZED)
APP_ENV_INITIALIZED = true

APP_ROOT = File.expand_path("..", __dir__) unless defined?(APP_ROOT)
$LOAD_PATH.unshift(APP_ROOT) unless $LOAD_PATH.include?(APP_ROOT)

require 'dotenv'
Dotenv.load

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
require 'grape-rabl'

require 'appsignal'
require 'active_support'

# Markdown rendering
require 'kramdown'
Tilt.prefer Tilt::KramdownTemplate

module Grape
  module Rabl
    class Formatter
      private

      def fallback_formatter
        Grape::Formatter::Json
      end
    end
  end
end

# Notifications
require 'pony'

# Configuration files
require 'config/secrets'
require 'config/pony'
require 'config/rabl'
require 'config/active_record'

# Models
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each {|f| require f}
