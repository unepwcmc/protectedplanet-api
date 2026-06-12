module Web; end

class Web::BaseController < Sinatra::Base
  set :erb, escape_html: true
  set :views, File.expand_path('views', __dir__)
end
