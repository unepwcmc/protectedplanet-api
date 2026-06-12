require 'net/http'
require 'json'

module TurnstileVerifier
  class SiteverifyError < StandardError; end

  VERIFY_URL = 'https://challenges.cloudflare.com/turnstile/v0/siteverify'
  RESPONSE_PARAM = 'cf-turnstile-response'
  OPEN_TIMEOUT = 3
  READ_TIMEOUT = 5

  REQUIRED_ENVIRONMENTS = %w[production staging].freeze

  def self.enabled?
    site_key.present? && secret_key.present?
  end

  def self.required?
    REQUIRED_ENVIRONMENTS.include?($environment)
  end

  def self.site_key
    $secrets.dig(:turnstile, :site_key).to_s.strip
  end

  def self.secret_key
    $secrets.dig(:turnstile, :secret_key).to_s.strip
  end

  def self.failed_verification?(params, remote_ip: nil)
    unless enabled?
      log_missing_configuration if required?
      return required?
    end

    token = params[RESPONSE_PARAM]
    return true if token.to_s.strip.empty?

    !verify(token, remote_ip: remote_ip)
  end

  def self.verify(token, remote_ip: nil)
    uri = URI(VERIFY_URL)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(
      'secret' => secret_key,
      'response' => token.to_s,
      'remoteip' => remote_ip.to_s
    )

    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: true,
      open_timeout: OPEN_TIMEOUT,
      read_timeout: READ_TIMEOUT
    ) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      log_verification_error("HTTP #{response.code}")
      return false
    end

    JSON.parse(response.body)['success'] == true
  rescue StandardError => e
    log_verification_error("#{e.class}: #{e.message}")
    false
  end

  def self.log_missing_configuration
    warn('[TurnstileVerifier] Turnstile keys missing in production/staging; blocking submission')

    return if $environment == 'test'

    AppsignalNotifier.report_error(
      SiteverifyError.new('Turnstile keys not configured'),
      namespace: 'turnstile_verifier',
      action: 'TurnstileVerifier#log_missing_configuration'
    )
  rescue StandardError => e
    warn("[TurnstileVerifier] Failed to log missing configuration: #{e.message}")
  end
  private_class_method :log_missing_configuration

  def self.log_verification_error(detail)
    warn("[TurnstileVerifier] Siteverify error: #{detail}")

    return if $environment == 'test'

    Appsignal.increment_counter('turnstile_siteverify_error', 1)
    AppsignalNotifier.report_error(
      SiteverifyError.new(detail),
      namespace: 'turnstile_verifier',
      action: 'TurnstileVerifier#log_verification_error',
      tags: { detail: detail.to_s[0, 100] }
    )
  rescue StandardError => e
    warn("[TurnstileVerifier] Failed to log siteverify error: #{e.message}")
  end
  private_class_method :log_verification_error
end
