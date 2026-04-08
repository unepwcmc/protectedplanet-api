require 'rack'
require_relative '../environment'

# Must live in config.ru: `use` only works in Rack::Builder context (not inside required files).
use ActiveRecordConnectionManagement

require_relative '../cors_origins'
require_relative '../../api/root'
require_relative '../../web/root'

use Rack::Session::Cookie, secret: ENV['RACK_SESSION_SECRET']
use Rack::Csrf, raise: true
use Rack::Config do |env|
  env['api.tilt.root'] = File.expand_path('../../api', __dir__)
end

CorsOrigins.use_rack_cors(self)

run Rack::Cascade.new [Web::Root, API::Root]
