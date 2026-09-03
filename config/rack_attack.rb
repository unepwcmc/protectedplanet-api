# frozen_string_literal: true

require 'rack/attack'
require 'active_support'
require 'active_support/cache'
require 'active_support/core_ext/object/blank'
require 'api/auth_token'

# Caps how many requests a single client can make, so one heavy API token (or a token-less
# flood) can't consume the whole Puma thread pool and starve everyone else.
#
# In-process MemoryStore: each Puma worker enforces its own counter, so the effective
# ceiling is roughly limit * PUMA_WORKERS, not a hard cluster-wide cap. That's an accepted
# tradeoff for a first line of defense — there's no Redis in front of this app yet. Move to
# a shared store (e.g. Redis) if a tighter, cluster-wide limit is needed later.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle('api/token-or-ip', limit: 30, period: 10) do |req|
  next unless req.path.match?(%r{\A/v[34]/})

  token = API::AuthToken.from_rack_params_and_env(req.params, req.env)
  token.presence || req.ip
end

Rack::Attack.throttled_responder = lambda do |req|
  match_data = req.env['rack.attack.match_data'] || {}
  headers = {
    'Content-Type' => 'application/json',
    'Retry-After' => match_data[:period].to_s
  }
  [429, headers, [{ error: 'Rate limit exceeded. Please slow down and try again shortly.' }.to_json]]
end
