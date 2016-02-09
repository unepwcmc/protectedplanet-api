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

require 'active_support'

# Markdown rendering
require 'kramdown'
Tilt.prefer Tilt::KramdownTemplate

# Configuration files
require 'config/rabl'
require 'config/active_record'

# Models
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each {|f| require f}
