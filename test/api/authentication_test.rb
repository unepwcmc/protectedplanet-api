require 'test_helper'
require 'api/root'

class API::Authentication < Minitest::Test
  include Rack::Test::Methods

  def app
    API::Root
  end

  def test_get_test_returns_401_on_wrong_token
    get_json_api '/test', token: 'wrong token'

    refute last_response.ok?
    assert_equal last_response.status, 401
  end

  def test_get_test_returns_200_on_good_token
    user = ApiUser.create(token: 'thetoken', active: true)
    get_json_api '/test', { token: user.token }

    assert last_response.ok?
    assert_equal JSON.parse(last_response.body), { 'status' => 'Success!' }
  end

  def test_get_test_returns_200_with_authorization_bearer_token
    get '/test', {},
        { 'api.tilt.root' => 'api', 'HTTP_AUTHORIZATION' => "Bearer #{TEST_API_TOKEN}" }

    assert last_response.ok?
    assert_equal JSON.parse(last_response.body), { 'status' => 'Success!' }
    assert_nil last_response.headers['Deprecation']
  end

  def test_deprecation_header_when_token_in_query_params
    get_json_api '/test'

    assert last_response.ok?
    assert_equal 'true', last_response.headers['Deprecation']
    assert last_response.headers['Warning']&.include?('deprecated')
  end

  def test_get_test_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_json_api '/test', { token: user.token }

    refute last_response.ok?
    assert_equal last_response.status, 401
  end
end
