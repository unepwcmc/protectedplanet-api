require 'erb'

module Mailer
  NEW_REQUEST_TEMPLATE = ERB.new(File.read("lib/templates/new_request_notification.erb"))
  def self.send_new_request_notification api_user, activation_url
    Pony.mail(
      to: $secrets[:mailer][:notifications_recipients],
      subject: "New API token request",
      html_body: NEW_REQUEST_TEMPLATE.result(binding)
    )
  end

  NEW_ACTIVATION_TEMPLATE = ERB.new(File.read("lib/templates/new_activation_notification.erb"))
  def self.send_new_activation_notification api_user, documentation_url
    Pony.mail(
      to: api_user.email,
      subject: "Your Protected Planet API token",
      html_body: NEW_ACTIVATION_TEMPLATE.result(binding)
    )
  end

  API_IS_LIVE_TEMPLATE = ERB.new(File.read("lib/templates/api_is_live.html.erb"))
  def self.send_api_is_live_notification api_user
    Pony.mail(
      to: api_user.email,
      subject: "Protected Planet API is live!",
      html_body: API_IS_LIVE_TEMPLATE.result(binding)
    )
  end

  API_IS_NOW_HTTPS_TEMPLATE = ERB.new(File.read("lib/templates/api_is_now_https.html.erb"))
  def self.send_api_is_now_https_notification api_user
    Pony.mail(
      to: api_user.email,
      subject: "Protected Planet API is live!",
      html_body: API_IS_NOW_HTTPS_TEMPLATE.result(binding)
    )
  end
end
