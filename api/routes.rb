module API; end
module API::V3; end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|f| require f}

module API
  class Routes < Grape::API
    format :json
    formatter :json, Grape::Formatter::Rabl

    version "v3"
    mount API::V3::ProtectedAreas
    mount API::V3::Countries
  end
end
