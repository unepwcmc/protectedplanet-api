module Web; end

class Web::PrivacyPolicyController < Sinatra::Base
  set :views, File.join(settings.root, '../views')

  get("/privacy-policy") do
    erb :privacy_policy, layout: :layout
  end
end
