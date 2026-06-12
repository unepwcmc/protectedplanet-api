# Bot protection for POST /submit-request-new-user (honeypot).
# Honeypot field markup: web/views/request/_honeypot.rhtml
module ApiRequestProtection
  class BotSubmissionSuppressed < StandardError; end

  # Nonsense field name/label to avoid browser/password-manager autofill heuristics.
  HONEYPOT_FIELD = 'contact_preference_x'
  HONEYPOT_LABEL = 'Contact preference code'
  HONEYPOT_CSS_CLASS = 'api-request-contact-preference-x'

  module_function

  def bot_detection_reasons(params, _session = nil)
    reasons = []
    reasons << 'honeypot_filled' if honeypot_filled?(params)
    reasons
  end

  def bot_submission?(params, session = nil)
    bot_detection_reasons(params, session).any?
  end

  def honeypot_filled?(params)
    params[HONEYPOT_FIELD].to_s.strip != ''
  end

  def log_bot_detection(reasons)
    checks = reasons.join(',')
    STDERR.puts("[ApiRequestProtection] Suppressed submission checks=#{checks}")

    return if $environment == 'test'

    # Counters aggregate volume by check type only (not per email).
    reasons.each do |check|
      Appsignal.increment_counter("api_request_bot_detection_#{check}", 1)
    end

    AppsignalNotifier.report_error(
      BotSubmissionSuppressed.new("checks=#{checks}"),
      namespace: 'api_request_protection',
      action: 'ApiRequestProtection#log_bot_detection',
      tags: { checks: checks }
    )
  rescue StandardError => e
    STDERR.puts("[ApiRequestProtection] Failed to log bot detection: #{e.message}")
  end
end
