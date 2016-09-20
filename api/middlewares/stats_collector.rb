require 'api/helpers'

module Middlewares; end

class Middlewares::StatsCollector < Grape::Middleware::Base
  PAS_PATH_REGEXP       = Regexp.compile("/v./protected_areas")
  COUNTRIES_PATH_REGEXP = Regexp.compile("/v./countries")

  def after
    params = env["rack.request.query_hash"]

    if token = params["token"]
      Appsignal.increment_counter("total_hits", 1)
      Appsignal.increment_counter("token_#{token}_hits", 1)

      if env["PATH_INFO"] =~ PAS_PATH_REGEXP
        Appsignal.increment_counter("protected_areas_hits", 1)
      end

      if env["PATH_INFO"] =~ COUNTRIES_PATH_REGEXP
        Appsignal.increment_counter("countries_hits", 1)
      end
    end
  end
end
