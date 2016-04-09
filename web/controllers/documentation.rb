module Web
  module DocumentationController
    # Routes
    ########
    SHOW_DOCUMENTATION = -> {
      erb :documentation, layout: :layout
    }

    # Register to Sinatra app
    #########################
    def self.registered(app)
      app.get "/documentation", &SHOW_DOCUMENTATION
    end
  end
end

