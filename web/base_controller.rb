module Web; end

class Web::BaseController < Sinatra::Base
  set :erb, escape_html: true
  set :views, File.expand_path('views', __dir__)
  set :static_cache_control, [:public, { max_age: 2_592_000 }] # 30 days
end
