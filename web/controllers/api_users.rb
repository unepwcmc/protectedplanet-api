module Web
  module ApiUsersController
    def self.registered(app)
      app.get "/api_users/:token/activate", &ACTIVATE_USER
      app.get "/api_users/:token/deactivate", &DEACTIVATE_USER
    end

    ACTIVATE_USER = -> do
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

    DEACTIVATE_USER = -> do
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
  end
end
