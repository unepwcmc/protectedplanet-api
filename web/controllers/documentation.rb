module Web; end

require "web/base_controller"

class Web::DocumentationController < Web::BaseController

  get("/documentation") do
    erb :documentation, layout: :layout
  end

  get("/documentation/v3") do
    erb :"documentation/v3/documentation", layout: :layout
  end

  get("/documentation/whats_new_in_v4") do
    erb :"shared/_whats_new_in_v4", layout: :layout
  end
end

