if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

ENV['RACK_ENV'] ||= 'test'
TEST_API_TOKEN = '123890123890'

require 'minitest/autorun'
require 'rack/test'
require 'factory_bot'
require_relative '../config/environment'
require 'database_cleaner/active_record'
require_relative 'support/contract_samples'
require_relative 'api/v4/contract_helpers'
require_relative 'api/v3/contract_helpers'

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

    def get_json_api(path, params = {}, headers = {})
      get path, { token: TEST_API_TOKEN }.merge(params), { 'api.tilt.root' => 'api' }.merge(headers)
      @json_response = begin
        JSON.parse(last_response.body)
      rescue StandardError
        nil
      end
    end

    def parse_last_response_json
      JSON.parse(last_response.body)
    rescue StandardError
      nil
    end

    def assert_error_response(status, response_payload = @json_response)
      assert_equal status, last_response.status
      if response_payload.is_a?(Array)
        refute_empty response_payload, 'expected non-empty validation error payload'
        first_error = response_payload.first
        assert_kind_of Hash, first_error, 'expected validation error item to be a hash'
        refute_empty Array(first_error['messages']), "expected validation payload to include 'messages'"
      else
        assert_kind_of Hash, response_payload, 'expected JSON object response payload'
        message = response_payload['error'] || response_payload['message']
        refute_nil message, "expected error payload to include 'error' or 'message'"
        refute_empty message.to_s.strip
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
