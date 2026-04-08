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
    post path, { token: TEST_API_TOKEN }, { 'api.tilt.root' => 'api' }
    refute last_response.ok?

    put path, { token: TEST_API_TOKEN }, { 'api.tilt.root' => 'api' }
    refute last_response.ok?

    patch path, { token: TEST_API_TOKEN }, { 'api.tilt.root' => 'api' }
    refute last_response.ok?

    delete path, { token: TEST_API_TOKEN }, { 'api.tilt.root' => 'api' }
    refute last_response.ok?
  end
end
