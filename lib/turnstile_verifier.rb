require 'net/http'
require 'json'

module TurnstileVerifier
  VERIFY_URL = 'https://challenges.cloudflare.com/turnstile/v0/siteverify'
  RESPONSE_PARAM = 'cf-turnstile-response'

  def self.enabled?
    site_key.present? && secret_key.present?
  end

  def self.site_key
    $secrets.dig(:turnstile, :site_key).to_s.strip
  end

  def self.secret_key
    $secrets.dig(:turnstile, :secret_key).to_s.strip
  end

  def self.failed_verification?(params, remote_ip: nil)
    return false unless enabled?

    token = params[RESPONSE_PARAM]
    return true if token.to_s.strip.empty?

    !verify(token, remote_ip: remote_ip)
  end

  def self.verify(token, remote_ip: nil)
    uri = URI(VERIFY_URL)
    response = Net::HTTP.post_form(
      uri,
      'secret' => secret_key,
      'response' => token.to_s,
      'remoteip' => remote_ip.to_s
    )

    JSON.parse(response.body)['success'] == true
  rescue StandardError
    false
  end
end
