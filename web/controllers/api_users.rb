module Web
  module ApiUsersController
    # Routes
    ########
    ACTIVATE_USER = -> {
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
    }

    DEACTIVATE_USER = -> {
      protected!

      if api_user = ApiUser.find_by_token(params["token"])
        api_user.deactivate!
        "User successfully deactivated!"
      else
        "User not found!"
      end
    }


    # Register to Sinatra app
    #########################
    def self.registered(app)
      app.get "/api_users/:token/activate", &ACTIVATE_USER
      app.get "/api_users/:token/deactivate", &DEACTIVATE_USER
    end
  end
end
