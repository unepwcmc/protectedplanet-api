require 'slack-notifier'
require 'exception_notification'
require 'api/helpers'
require 'api/middlewares/stats_collector'
require 'grape_logging'

module API; end
module API::V3; end
module API::V4; end

api_dir = File.dirname(__FILE__)
Dir["#{api_dir}/**/*.rb"].sort.each do |path|
  next if path == __FILE__

  require path
end

module API
  class Root < Grape::API
    if ENV['RACK_ENV'] != 'test' && defined?(Appsignal::Rack::GrapeMiddleware)
      insert_before Grape::Middleware::Error, Appsignal::Rack::GrapeMiddleware
    end

    use Middlewares::StatsCollector

    helpers API::Helpers
    log_output = STDOUT
    logger = Logger.new(log_output)
    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger } unless ENV['RACK_ENV'] == 'test'

    rescue_from :all do |e|
      logger.error e
      ExceptionNotifier.notify_exception(e)

      error!({ error: 'unexpected error' }, 500)
    end

    format :json
    formatter :json, Grape::Formatter::Json
    content_type :json, 'application/json; charset=utf-8'

    before do
      authenticate!
    end

    get 'test' do
      { status: 'Success!' }
    end

    version 'v3' do
      resources :protected_areas do
        mount API::V3::ProtectedAreas
      end

      resources :countries do
        mount API::V3::Countries
      end
    end

    version 'v4' do
      resources :protected_areas do
        mount API::V4::ProtectedAreas
      end

      resources :protected_area_parcels do
        mount API::V4::ProtectedAreaParcels
      end

      resources :countries do
        mount API::V4::Countries
      end
    end
  end
end
