ENV["API_ENV"] = ENV["RACK_ENV"] = ENV["RAILS_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require "factory_girl"
require "database_cleaner"
require "config/environment"

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

class Minitest::Test
  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def get_with_rabl path, params={}
    get path, params, {"api.tilt.root" => "api"}
    @json_response = JSON.parse(last_response.body) rescue nil
  end
end

FactoryGirl.find_definitions
