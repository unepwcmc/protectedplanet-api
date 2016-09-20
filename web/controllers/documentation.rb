module Web; end

class Web::DocumentationController < Sinatra::Base
  set :views, File.join(settings.root, '../views')

  get("/documentation") do
    erb :documentation, layout: :layout
  end
end

