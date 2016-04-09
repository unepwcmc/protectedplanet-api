module Web
  module DocumentationController
    def self.registered(app)
      app.get "/documentation", &SHOW_DOCUMENTATION
    end

    SHOW_DOCUMENTATION = -> do
      erb :documentation, layout: :layout
    end
  end
end

