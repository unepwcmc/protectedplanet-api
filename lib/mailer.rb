module Mailer
  NEW_REQUEST_TEMPLATE = ERB.new(File.read("lib/templates/new_request_notification.erb"))
  def self.send_new_request_notification api_user
    Pony.mail(
      to: $secrets[:mailer][:notifications_recipients],
      subject: "New API token request",
      body: NEW_REQUEST_TEMPLATE.result(binding)
    )
  end
end
