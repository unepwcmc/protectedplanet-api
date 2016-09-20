module Web; end

class Web::RequestsController < Sinatra::Base
  set :views, File.join(settings.root, '../views')

  get("/request") do
    erb :request, layout: :layout
  end

  post("/request") do
    if @new_user = create_api_user(params)
      Thread.new{ send_notification(@new_user) }
      erb :request_success, layout: :layout
    else
      erb :request_error, layout: :layout
    end
  end

  private

  def send_notification(new_user)
    activation_url = url("/admin")
    Mailer.send_new_request_notification(new_user, activation_url)
  end

  def create_api_user params
    ApiUser.create(
      email:      params["email"],
      full_name:  params["fullname"],
      company:    params["company"],
      reason:     params["reason"],
      active:     false,
      token:      ApiUser.new_token
    )
  end
end
