module Web
  module RequestsController
    def self.registered(app)
      app.get  "/request", &SHOW_REQUEST
      app.post "/request", &POST_REQUEST
    end

    SHOW_REQUEST = -> do
      erb :request, layout: :layout
    end

    POST_REQUEST = -> do
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
  end
end
