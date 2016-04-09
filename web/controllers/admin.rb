module Web
  module AdminController
    # Routes
    ########
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
        user.active = params["api_user"]["active"].present?

        params["api_user"]["permissions"].each do |(api_object, attrs)|
          user.permissions[api_object] = attrs.keys
        end

        user.save
      end

      redirect back
    }

    SIGN_OUT = -> {
      protected!
      session.destroy

      redirect "/"
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
