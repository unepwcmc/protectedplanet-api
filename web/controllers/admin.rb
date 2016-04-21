module Web
  module AdminController
    # Routes implementation
    #######################
    SHOW_ADMIN = -> {
      protected!
      erb :admin, layout: :layout
    }

    UPDATE_API_USER = -> {
      protected!
      user = ApiUser.find(params[:id])

      if params.has_key?("destroy")
        user.destroy
      elsif params.has_key?("save")
        UPDATE_USER[user, params["api_user"]]
        user.save
      end

      redirect back
    }

    SIGN_OUT = -> {
      protected!
      session.destroy

      redirect "/"
    }

    # Private implementation
    ########################
    UPDATE_USER = -> (user, params) {
      if params["active"].present?
        user.activate!
      else
        user.deactivate!
      end

      params["permissions"].each do |(api_object, attrs)|
        user.permissions[api_object] = attrs.keys
      end
    }

    # Register to Sinatra app
    #########################
    def self.registered(app)
      app.get  "/admin", &SHOW_ADMIN
      app.get  "/admin/sign_out", &SIGN_OUT
      app.post "/admin/api_users/:id", &UPDATE_API_USER
    end
  end
end
