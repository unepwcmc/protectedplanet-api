require 'appsignal/integrations/grape'
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
    use Appsignal::Grape::Middleware
    use Middlewares::StatsCollector

    helpers API::Helpers

    unless $environment == "test"
      log_file = File.open("log/#{$environment}.log", "a")
      log_file.sync = true

      logger = Logger.new(GrapeLogging::MultiIO.new(STDOUT, log_file))
      logger.formatter = GrapeLogging::Formatters::Default.new

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
