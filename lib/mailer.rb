module Mailer
  require 'erb'

  template_dir = File.join(APP_ROOT, 'lib', 'templates')
  NEW_REQUEST_TEMPLATE = ERB.new(File.read(File.join(template_dir, 'new_request_notification.erb')))
  def self.send_new_request_notification(api_user, activation_url)
    Pony.mail(
      to: APP_SECRETS[:mailer][:notifications_recipients],
      subject: 'New API token request',
      html_body: NEW_REQUEST_TEMPLATE.result(binding)
    )
  end

  NEW_ACTIVATION_TEMPLATE = ERB.new(File.read(File.join(template_dir, 'new_activation_notification.erb')))
  def self.send_new_activation_notification(api_user, documentation_url)
    Pony.mail(
      to: api_user.email,
      subject: 'Your Protected Planet API token',
      html_body: NEW_ACTIVATION_TEMPLATE.result(binding)
    )
  end
end
