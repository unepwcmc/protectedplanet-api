$environment = (ENV["API_ENV"] || ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development")

require 'dotenv'
Dotenv.load

# Sinatra
require 'rack/csrf'
require 'sinatra'

# Grape
require 'grape'
require 'action_view'
require 'grape-rabl'
require 'grape-kaminari'

require 'appsignal'
require 'appsignal/integrations/grape'
Appsignal.start

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
