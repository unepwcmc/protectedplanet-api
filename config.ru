require 'rack'
require_relative 'config/environment'

use Rack::Reloader, 0 if APP_ENV == 'development'

require 'appsignal'
Appsignal.load(:grape) unless APP_ENV == 'test'

require_relative 'api/root'
require_relative 'web/root'

use Rack::Session::Cookie, secret: ENV['RACK_SESSION_SECRET']
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

use Appsignal::Rack::EventMiddleware unless APP_ENV == 'test'
Appsignal.start unless APP_ENV == 'test'

run Rack::Cascade.new [Web::Root, API::Root]
