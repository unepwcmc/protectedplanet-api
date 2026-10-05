# frozen_string_literal: true

# Resolves the real client IP behind Cloudflare + kamal-proxy. Neither hop is a bare
# reverse proxy nginx used to strip trust boundaries for (set_real_ip_from/real_ip_header);
# kamal-proxy just forwards whatever header it received, so callers that need the real
# visitor IP (rate limiting, Turnstile) must resolve it themselves.
module ClientIp
  def self.resolve(env)
    cf_ip = env['HTTP_CF_CONNECTING_IP']
    return cf_ip unless cf_ip.nil? || cf_ip.empty?

    forwarded = env['HTTP_X_FORWARDED_FOR']
    return forwarded.split(',').first.strip unless forwarded.nil? || forwarded.empty?

    Rack::Request.new(env).ip
  end
end
