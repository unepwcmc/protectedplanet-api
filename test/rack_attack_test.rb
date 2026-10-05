# frozen_string_literal: true

require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../config/rack_attack'

class RackAttackTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use Rack::Attack
      run ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['ok']] }
    end
  end

  def setup
    @throttle = Rack::Attack.throttles.fetch('api/token-or-ip')
    @original_limit = @throttle.instance_variable_get(:@limit)
    @throttle.instance_variable_set(:@limit, 2)
    Rack::Attack.cache.store.clear
  end

  def teardown
    @throttle.instance_variable_set(:@limit, @original_limit)
    Rack::Attack.cache.store.clear
  end

  def test_throttles_repeated_requests_from_the_same_token
    3.times { get '/v4/protected_areas', token: 'abc' }

    assert_equal 429, last_response.status
    assert_equal 'application/json', last_response.headers['Content-Type']
    assert_equal(
      'Rate limit exceeded. Please slow down and try again shortly.',
      JSON.parse(last_response.body)['error']
    )
  end

  def test_does_not_throttle_non_api_paths
    5.times { get '/' }

    assert_equal 200, last_response.status
  end

  def test_different_tokens_are_throttled_independently
    2.times { get '/v4/protected_areas', token: 'token-a' }
    get '/v4/protected_areas', token: 'token-b'

    assert_equal 200, last_response.status
  end
end
