ENV['RACK_ENV'] = 'test'
TEST_API_TOKEN = '123890123890'

require 'minitest/autorun'
require 'rack/test'
require 'factory_bot'
require_relative '../config/environment'
require 'database_cleaner/active_record'
require_relative 'support/contract_samples'
require_relative 'api/v4/contract_helpers'
require_relative 'api/v3/contract_helpers'

MiniTest = Minitest unless defined?(MiniTest)

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

module Minitest
  class Test
    include FactoryBot::Syntax::Methods

    def setup
      DatabaseCleaner.start
      ApiUser.create(token: TEST_API_TOKEN, active: true)
    end

    def teardown
      DatabaseCleaner.clean
    end

    def get_with_rabl(path, params = {})
      get path, { token: TEST_API_TOKEN }.merge(params), { 'api.tilt.root' => 'api' }
      @json_response = begin
        JSON.parse(last_response.body)
      rescue StandardError
        nil
      end
    end
  end
end

class TestClass
  def self.remove_module(mod)
    mod.instance_methods.each do |m|
      next if %i[object_id __send__].include?(m)

      undef_method(m)
    end
  end
end

FactoryBot.find_definitions
