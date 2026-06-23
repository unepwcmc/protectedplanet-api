module Web; end

require 'web/base_controller'

class Web::RequestsController < Web::BaseController
  get('/request') do
    @turnstile_site_key = TurnstileVerifier.site_key if TurnstileVerifier.enabled?
    erb :request, layout: :layout
  end

  get('/submit-request-new-user') do
    redirect '/request'
  end

  post('/submit-request-new-user') do
    if (bot_reasons = ApiRequestProtection.bot_detection_reasons(params)).any?
      ApiRequestProtection.log_bot_detection(bot_reasons)
      @false_success = true
      return erb :request_success, layout: :layout
    end

    if TurnstileVerifier.failed_verification?(params, remote_ip: client_ip)
      @errors = ['Verification failed. Please complete the security check and try again.']
      return erb :request_error, layout: :layout
    end

    email = ApiUser.normalize_email(params['email'])

    if (active_user = ApiUser.active_user_for_email(email))
      @false_success = true
      return erb :request_success, layout: :layout
    end

    if (pending_user = ApiUser.pending_user_for_email(email))
      @false_success = true
      @new_user = pending_user
      return erb :request_success, layout: :layout
    end

    @new_user = create_api_user(params)
    if @new_user.persisted?
      Thread.new { send_notification(@new_user) }
      erb :request_success, layout: :layout
    else
      @errors = @new_user.errors.full_messages
      erb :request_error, layout: :layout
    end
  end

  private

  def client_ip
    request.env['HTTP_CF_CONNECTING_IP'].presence ||
      request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first&.strip ||
      request.ip
  end

  def send_notification(new_user)
    activation_url = url('/admin')
    Mailer.send_new_request_notification(new_user, activation_url)
  end

  def create_api_user(params)
    user = ApiUser.new(
      email: params['email'],
      full_name: params['fullname'],
      company: params['company'],
      reason: params['reason'],
      licence_number: params['licence_number'],
      has_licence: params['has_licence'],
      kind: params['kind'],
      token: ApiUser.new_token,
      active: false
    )
    user.save(context: :request)
    user
  end
end
