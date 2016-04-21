module Web
  module RequestsController
    # Routes
    ########
    SHOW_REQUEST = -> {
      erb :request, layout: :layout
    }

    POST_REQUEST = -> {
      if @new_user = create_api_user(params)
        Thread.new {
          activation_url = url("/admin")
          Mailer.send_new_request_notification(@new_user, activation_url)
        }
        erb :request_success, layout: :layout
      else
        erb :request_error, layout: :layout
      end
    }

    # Register to Sinatra app
    #########################
    def self.registered(app)
      app.get  "/request", &SHOW_REQUEST
      app.post "/request", &POST_REQUEST
    end
  end
end
