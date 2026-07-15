module Web; end

require "web/base_controller"

class Web::PrivacyPolicyController < Web::BaseController

  get('/privacy-policy') do
    erb :privacy_policy, layout: :layout
  end
end
