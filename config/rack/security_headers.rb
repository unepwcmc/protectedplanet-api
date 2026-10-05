class SecurityHeaders
  DEFAULT_HEADERS = {
    'X-Frame-Options' => 'DENY',
    'X-Content-Type-Options' => 'nosniff',
    'Referrer-Policy' => 'strict-origin-when-cross-origin',
    'Permissions-Policy' => 'camera=(), microphone=(), geolocation=()',
    'Strict-Transport-Security' => 'max-age=15768000'
  }.freeze

  DEFAULT_CSP = [
    "default-src 'self'",
    "base-uri 'self'",
    "frame-ancestors 'none'",
    "object-src 'none'",
    "img-src 'self' data: https:",
    "style-src 'self' 'unsafe-inline'",
    "script-src 'self' https://www.google-analytics.com https://challenges.cloudflare.com 'unsafe-inline'",
    'frame-src https://challenges.cloudflare.com',
    "connect-src 'self' https://www.google-analytics.com"
  ].join('; ').freeze

  def initialize(app, csp: DEFAULT_CSP)
    @app = app
    @csp = csp
  end

  def call(env)
    status, headers, response = @app.call(env)
    secure_headers = DEFAULT_HEADERS.merge('Content-Security-Policy' => @csp)
    [status, headers.merge(secure_headers), response]
  end
end
