# frozen_string_literal: true

require 'rack/cors'

# Comma-separated list of allowed browser origins, e.g.
#   CORS_ORIGINS=https://www.protectedplanet.net,https://localhost:3000
# If unset or empty, any origin is allowed (wildcard) — same as historical behaviour.
# Staging and production require an explicit list (see `ensure_explicit_origins!`).
module CorsOrigins
  module_function

  def ensure_explicit_origins!
    return unless %w[staging production].include?(ENV.fetch('RACK_ENV', ''))

    raw = ENV['CORS_ORIGINS']
    if raw.nil? || raw.strip.empty?
      raise(
        'CORS_ORIGINS must be set in staging/production to a comma-separated list of ' \
        'browser origins (e.g. https://www.protectedplanet.net). ' \
        'Empty or unset CORS is only allowed in development/test and maps to a wildcard (*); ' \
        'see README and .env.example.'
      )
    end
  end

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
