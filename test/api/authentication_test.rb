require "test_helper"
require "api/root"

class API::Authentication < MiniTest::Test
  include Rack::Test::Methods

  def app
    API::V3::ProtectedAreas
  end

  def test_get_protected_areas_returns_401_on_wrong_token
    get_with_rabl "/v3/protected_areas", token: "wrong token"

    refute last_response.ok?
    assert_equal last_response.status, 401
  end

  def test_get_protected_areas_returns_401_on_inactive_user
    user = ApiUser.create(token: "thetoken", active: false)
    get_with_rabl "/v3/protected_areas", {token: user.token}

    refute last_response.ok?
    assert_equal last_response.status, 401
  end
end
