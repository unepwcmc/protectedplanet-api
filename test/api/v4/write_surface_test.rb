require 'test_helper'
require 'api/root'

class API::V4::WriteSurfaceTest < Minitest::Test
  include Rack::Test::Methods

  def app
    API::Root
  end

  def test_v4_countries_write_methods_are_not_available
    assert_write_not_available('/v4/countries')
  end

  def test_v4_protected_areas_write_methods_are_not_available
    assert_write_not_available('/v4/protected_areas')
  end

  def test_v4_protected_area_parcels_write_methods_are_not_available
    assert_write_not_available('/v4/protected_area_parcels')
  end

  private

  def assert_write_not_available(path)
    assert_method_not_allowed(:post, path)
    assert_method_not_allowed(:put, path)
    assert_method_not_allowed(:patch, path)
    assert_method_not_allowed(:delete, path)
  end

  def assert_method_not_allowed(http_method, path)
    send(http_method, path, { token: TEST_API_TOKEN }, { 'api.tilt.root' => 'api' })
    refute last_response.ok?

    json = parse_last_response_json
    assert_includes [405, 500], last_response.status
    if [Hash, Array].any? { |klass| json.is_a?(klass) }
      assert_error_response(last_response.status, json)
    end
  end
end
