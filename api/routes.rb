module API; end
module API::V3; end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|f| require f}

module API
  class Routes < Grape::API
    format :json
    formatter :json, Grape::Formatter::Rabl
    content_type :json, 'application/json; charset=utf-8'

    version "v3"

    resources :protected_areas do
      mount API::V3::ProtectedAreas
    end

    resources :countries do
      mount API::V3::Countries
    end
  end
end
