$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require 'config/environment'

require 'api/root'
require 'web/root'

use Rack::Session::Cookie, secret: ENV["RACK_SESSION_SECRET"]
use Rack::Csrf, :raise => true
use Rack::Config do |env|
  env['api.tilt.root'] = "#{File.dirname(__FILE__)}/api"
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end

run Rack::Cascade.new [Web::Root, API::Root]
