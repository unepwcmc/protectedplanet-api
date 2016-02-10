require 'api/helpers'

module API; end
module API::V3; end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|f| require f}

module API
  class Root < Grape::API
    helpers API::Helpers

    format :json
    formatter :json, Grape::Formatter::Rabl
    content_type :json, 'application/json; charset=utf-8'

    before do
      authenticate!
    end

    get "test" do
      {status: "Success!"}
    end

    version "v3" do
      resources :protected_areas do
        mount API::V3::ProtectedAreas
      end

      resources :countries do
        mount API::V3::Countries
      end
    end
  end
end
