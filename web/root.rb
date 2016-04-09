require "lib/mailer"

require "web/helpers"
require "web/controllers/admin"
require "web/controllers/api_users"
require "web/controllers/documentation"
require "web/controllers/requests"

module Web
  class Root < Sinatra::Base
    get "/" do
      erb :home, layout: :layout
    end

    helpers Web::Helpers

    register Web::AdminController
    register Web::ApiUsersController
    register Web::DocumentationController
    register Web::RequestsController
  end
end
