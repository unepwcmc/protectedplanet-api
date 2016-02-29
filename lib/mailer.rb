module Mailer
  NEW_REQUEST_TEMPLATE = ERB.new(File.read("lib/templates/new_request_notification.erb"))
  def self.send_new_request_notification api_user, activation_url
    Pony.mail(
      to: $secrets[:mailer][:notifications_recipients],
      subject: "New API token request",
      html_body: NEW_REQUEST_TEMPLATE.result(binding)
    )
  end
end
