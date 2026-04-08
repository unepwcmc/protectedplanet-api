# frozen_string_literal: true

require 'rack/cors'

# Comma-separated list of allowed browser origins, e.g.
#   CORS_ORIGINS=https://www.protectedplanet.net,https://localhost:3000
# If unset or empty, any origin is allowed (wildcard) — same as historical behaviour.
module CorsOrigins
  module_function

  def rack_cors_origins
    raw = ENV['CORS_ORIGINS']
    return '*' if raw.nil? || raw.strip.empty?

    list = raw.split(',').map(&:strip).reject(&:empty?)
    return '*' if list.empty?

    list.size == 1 ? list.first : list
  end

  # Rack middleware must be registered on a Rack::Builder instance. Call from
  # config/rack/<env>.rb as: CorsOrigins.use_rack_cors(self)
  # (`self` is the builder when that file is instance_eval'd from config.ru.)
  def use_rack_cors(builder)
    builder.use Rack::Cors do
      allow do
        origins CorsOrigins.rack_cors_origins
        resource '*', headers: :any, methods: %i[get post options]
      end
    end
  end
end
