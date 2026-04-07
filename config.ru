require 'rack'
require_relative 'config/environment'

# Must live in config.ru: `use` only works in Rack::Builder context (not inside required files).
use ActiveRecordConnectionManagement

use Rack::Reloader, 0 if API_APP_ENV == 'development'

Appsignal.load(:grape) unless API_APP_ENV == 'test'

require_relative 'api/root'
require_relative 'web/root'

use Rack::Session::Cookie, secret: ENV['RACK_SESSION_SECRET']
use Rack::Csrf, raise: true
use Rack::Config do |env|
  env['api.tilt.root'] = "#{File.dirname(__FILE__)}/api"
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post options]
  end
end

use Appsignal::Rack::EventMiddleware unless API_APP_ENV == 'test'
Appsignal.start unless API_APP_ENV == 'test'

run Rack::Cascade.new [Web::Root, API::Root]
