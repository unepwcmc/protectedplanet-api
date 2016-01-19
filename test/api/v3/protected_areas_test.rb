require "test_helper"
require "api/routes"

class API::V3::ProtectedAreasTest < MiniTest::Test
  include Rack::Test::Methods

  EXPECTED_GEOJSON = {
    "type" => "Feature",
    "properties" => {"fill-opacity" => 0.7, "stroke-width" => 0.05, "stroke" => "#40541b", "fill" => "#83ad35", "marker-color" => "#2B3146"},
    "geometry" => {"type" => "Point", "coordinates" => [-122, 47]}
  }

  def app
    API::V3::ProtectedAreas
  end

  def test_get_protected_areas_returns_all_protected_areas_as_JSON
    3.times { create(:protected_area) }
    get_with_rabl "/v3/protected_areas"

    assert last_response.ok?
    assert_equal 3, @json_response["protected_areas"].size
  end

  def test_get_protected_areas_with_geometry_true_returns_all_protected_areas_with_geojson
    3.times { create(:protected_area, the_geom: "POINT(-122 47)") }
    get_with_rabl "/v3/protected_areas", {with_geometry: true}

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response["protected_areas"][0]["geojson"])
  end

  def test_get_protected_areas_123_returns_protected_area_with_wdpa_id_123
    create(:protected_area, name: "Bad Wolf", wdpa_id: 123)
    get_with_rabl "/v3/protected_areas/123"

    assert last_response.ok?
    assert_equal(123, @json_response["protected_area"]["id"])
    assert_equal(123, @json_response["protected_area"]["wdpa_id"])
    assert_equal("Bad Wolf", @json_response["protected_area"]["name"])
  end

  def test_get_protected_areas_123_with_geometry_returns_protected_area_123_with_geojson
    create(:protected_area, name: "Bad Wolf", wdpa_id: 123, the_geom: "POINT(-122 47)")
    get_with_rabl "/v3/protected_areas/123"

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response["protected_area"]["geojson"])
  end
end

