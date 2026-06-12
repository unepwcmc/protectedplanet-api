require 'lib/mailer'

require "web/base_controller"
require "web/helpers"
require "web/controllers/admin"
require "web/controllers/documentation"
require "web/controllers/privacy_policy"
require "web/controllers/requests"

module Web
  class Root < Web::BaseController
    get "/" do
      erb :home, layout: :layout
    end

    use Web::AdminController
    use Web::DocumentationController
    use Web::PrivacyPolicyController
    use Web::RequestsController
  end
end
