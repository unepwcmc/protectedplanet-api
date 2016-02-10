require "test_helper"
require "api/root"

class API::Authentication < MiniTest::Test
  include Rack::Test::Methods

  def app
    API::Root
  end

  def test_get_test_returns_401_on_wrong_token
    get_with_rabl "/test", token: "wrong token"

    refute last_response.ok?
    assert_equal last_response.status, 401
  end

  def test_get_test_returns_200_on_good_token
    user = ApiUser.create(token: "thetoken", active: true)
    get_with_rabl "/test", {token: user.token}

    assert last_response.ok?
    assert_equal JSON.parse(last_response.body), {"status" => "Success!"}
  end

  def test_get_test_returns_401_on_inactive_user
    user = ApiUser.create(token: "thetoken", active: false)
    get_with_rabl "/test", {token: user.token}

    refute last_response.ok?
    assert_equal last_response.status, 401
  end
end
