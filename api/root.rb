require 'slack-notifier'
require 'exception_notification'
require 'api/helpers'
require 'api/middlewares/stats_collector'
require 'grape_logging'

module API; end
module API::V3; end
module API::V4; end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|f| require f}

module API
  class Root < Grape::API
    if APP_ENV != 'test' && defined?(Appsignal::Rack::GrapeMiddleware)
      insert_before Grape::Middleware::Error, Appsignal::Rack::GrapeMiddleware
    end

    use Middlewares::StatsCollector

    helpers API::Helpers

    log_output =
      if APP_ENV == "test"
        STDOUT
      else
        log_file = File.open("log/#{APP_ENV}.log", "a")
        log_file.sync = true
        GrapeLogging::MultiIO.new(STDOUT, log_file)
      end

    logger = Logger.new(log_output)
    logger.formatter = GrapeLogging::Formatters::Default.new

    unless APP_ENV == "test"
      use GrapeLogging::Middleware::RequestLogger, {logger: logger}
      use ExceptionNotification::Rack, slack: {
        webhook_url: ENV["SLACK_WEBHOOK_URL"],
        channel: "#protectedplanet-api",
        additional_parameters: {
          mrkdwn: true
        }
      }
    end

    rescue_from :all do |e|
      logger.error e
      Thread.new { ExceptionNotifier.notify_exception(e) }

      error!({error: 'unexpected error'}, 500)
    end

    format :json
    formatter :json, Grape::Formatter::Rabl
    content_type :json, 'application/json; charset=utf-8'

    before do
      authenticate!
    end

    get "test" do
      {status: "Success!"}
    end

    version "v3" do
      resources :protected_areas do
        mount API::V3::ProtectedAreas
      end

      resources :countries do
        mount API::V3::Countries
      end
    end

    version "v4" do
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
