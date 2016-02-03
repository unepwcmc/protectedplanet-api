require 'dotenv'
Dotenv.load

require 'rack/csrf'
require 'sinatra'
require 'grape'
require 'grape-rabl'
require 'grape-kaminari'
require 'active_support'

require 'config/rabl'
require 'config/active_record'

Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each {|f| require f}
