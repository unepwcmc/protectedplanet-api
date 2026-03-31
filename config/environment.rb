$environment = (ENV["API_ENV"] || ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development")

require 'dotenv'
Dotenv.load

require 'logger'
require 'bigdecimal'

# Ruby 2.7 removes `BigDecimal.new`, but ActiveSupport 4.2 still calls it.
unless BigDecimal.respond_to?(:new)
  class << BigDecimal
    def new(*args)
      BigDecimal(*args)
    end
  end
end

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
require 'grape-kaminari'

require 'appsignal'
Appsignal.start unless $environment == "test"

require 'active_support'

# Markdown rendering
require 'kramdown'
Tilt.prefer Tilt::KramdownTemplate

# Notifications
require 'pony'

# Configuration files
require 'config/secrets'
require 'config/pony'
require 'config/rabl'
require 'config/active_record'

# Models
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each {|f| require f}
