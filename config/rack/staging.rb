# Must live in config.ru: `use` only works in Rack::Builder context (not inside required files).
use ActiveRecordConnectionManagement

Appsignal.load(:grape)

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

use Appsignal::Rack::EventMiddleware
Appsignal.start unless

run Rack::Cascade.new [Web::Root, API::Root]
