require "test_helper"
require "api/routes"

class API::V3::CountriesTest < MiniTest::Test
  include Rack::Test::Methods

  EXPECTED_GEOJSON = {
    "type" => "Feature",
    "properties" => {"fill-opacity" => 0.7, "stroke-width" => 0.05, "stroke" => "#40541b", "fill" => "#83ad35", "marker-color" => "#2B3146"},
    "geometry" => {"type" => "Point", "coordinates" => [-122, 47]}
  }

  def app
    API::V3::Countries
  end

  def test_get_countries_returns_all_countries_as_JSON
    3.times { create(:country) }
    get_with_rabl "/v3/countries"

    assert last_response.ok?
    assert_equal 3, @json_response["countries"].size
  end

  def test_get_countries_with_geometry_true_returns_all_countries_with_geojson
    3.times { create(:country, bounding_box: "POINT(-122 47)") }
    get_with_rabl "/v3/countries", {with_geometry: true}

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response["countries"][0]["geojson"])
  end

  def test_get_countries_WES_returns_country_with_iso_3_WES
    create(:country, name: "Zubrowka", iso_3: "WES")
    get_with_rabl "/v3/countries/WES"

    assert last_response.ok?
    assert_equal("WES", @json_response["country"]["id"])
    assert_equal("WES", @json_response["country"]["iso_3"])
    assert_equal("Zubrowka", @json_response["country"]["name"])
  end

  def test_get_countries_WES_with_geometry_returns_country_WES_with_geojson
    create(:country, name: "Zubrowka", iso_3: "WES", bounding_box: "POINT(-122 47)")
    get_with_rabl "/v3/countries/WES"

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response["country"]["geojson"])
  end
end
