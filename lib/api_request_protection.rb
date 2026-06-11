# Bot protection for POST /submit-request-new-user (honeypot, timing).
# Honeypot field markup: web/views/request/_honeypot.rhtml
module ApiRequestProtection
  HONEYPOT_FIELD = 'company_website'
  HONEYPOT_LABEL = 'Company website'
  HONEYPOT_CSS_CLASS = 'api-request-company-website'
  MIN_FORM_SUBMIT_SECONDS = 5

  module_function

  def bot_submission?(params, session)
    honeypot_filled?(params) || submitted_too_quickly?(session)
  end

  def honeypot_filled?(params)
    params[HONEYPOT_FIELD].to_s.strip != ''
  end

  def submitted_too_quickly?(session)
    return false if $environment == 'test'

    loaded_at = session[:request_form_loaded_at]
    return true if loaded_at.nil?

    Time.now.to_i - loaded_at.to_i < MIN_FORM_SUBMIT_SECONDS
  end
end
