require "lib/mailer"

module Web
  class Root < Sinatra::Base
    get "/" do
      erb :home, layout: :layout
    end

    get "/documentation" do
      erb :documentation, layout: :layout
    end

    get "/request" do
      erb :request, layout: :layout
    end

    post "/request" do
      if @new_user = create_api_user(params)
        Thread.new {
          activation_url = url("/api_users/#{@new_user.token}/activate")
          Mailer.send_new_request_notification(@new_user, activation_url)
        }
        erb :request_success, layout: :layout
      else
        erb :request_error, layout: :layout
      end
    end

    get "/api_users/:token/activate" do
      protected!

      if api_user = ApiUser.find_by_token(params["token"])
        api_user.activate!
        Thread.new {
          documentation_url = url("/documentation")
          Mailer.send_new_activation_notification(api_user, documentation_url)
        }
        "User successfully activated!"
      else
        "User not found!"
      end
    end

    get "/api_users/:token/deactivate" do
      protected!

      if api_user = ApiUser.find_by_token(params["token"])
        api_user.deactivate!
        "User successfully deactivated!"
      else
        "User not found!"
      end
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

    helpers do
      def protected!
        return if authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials == [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
      end
    end
  end
end
