$environment = ENV["API_ENV"] = ENV["RACK_ENV"] = ENV["RAILS_ENV"] = "test"
TEST_API_TOKEN = "123890123890"

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
    ApiUser.create(token: TEST_API_TOKEN, active: true)
  end

  def teardown
    DatabaseCleaner.clean
  end

  def get_with_rabl path, params={}
    get path, {token: TEST_API_TOKEN}.merge(params), {"api.tilt.root" => "api"}
    @json_response = JSON.parse(last_response.body) rescue nil
  end
end

class TestClass
  def self.remove_module(mod)
    mod.instance_methods.each do |m|
      next if [:object_id, :__send__].include?(m)
      undef_method(m)
    end
  end
end

FactoryGirl.find_definitions
