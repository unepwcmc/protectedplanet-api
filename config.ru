$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'config/environment'

require 'api/routes'
require 'web/routes'

use Rack::Config do |env|
  env['api.tilt.root'] = "#{File.dirname(__FILE__)}/api"
end

run Rack::Cascade.new [Web::Routes, API::Routes]
