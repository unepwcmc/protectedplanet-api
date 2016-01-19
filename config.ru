$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'sinatra'
require 'grape'
require 'grape-rabl'
require 'grape-kaminari'
require 'active_record'
require 'active_support'

require 'config/rabl'
require 'config/active_record'

Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each {|f| require f}

require 'api/routes'
require 'web/routes'

use Rack::Config do |env|
  env['api.tilt.root'] = "#{File.dirname(__FILE__)}/api"
end

run Rack::Cascade.new [Web::Routes, API::Routes]
