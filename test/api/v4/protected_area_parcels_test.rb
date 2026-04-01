require "test_helper"
require "api/root"

class API::V4::ProtectedAreaParcelsTest < MiniTest::Test
  include Rack::Test::Methods

  EXPECTED_GEOJSON = {
    "type" => "Feature",
    "properties" => {"fill-opacity" => 0.7, "stroke-width" => 0.05, "stroke" => "#40541b", "fill" => "#83ad35", "marker-color" => "#2B3146"},
    "geometry" => {"type" => "Point", "coordinates" => [-122, 47]}
  }

  def app
    API::V4::ProtectedAreaParcels
  end

  def test_get_protected_area_parcels_returns_all_protected_area_parcels_as_JSON
    3.times { create(:protected_area_parcel) }
    get_with_rabl "/v4/protected_area_parcels"

    assert last_response.ok?
    assert_equal 3, @json_response["protected_area_parcels"].size
  end

  def test_get_protected_area_parcels_with_geometry_true_returns_all_protected_area_parcels_with_geojson
    3.times { create(:protected_area_parcel, the_geom: "POINT(-122 47)") }
    get_with_rabl "/v4/protected_area_parcels", {with_geometry: true}

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response["protected_area_parcels"][0]["geojson"])
  end

  def test_get_protected_area_parcels_search_with_country_returns_matching_parcels
    country = create(:country, name: "Zubrowka", iso_3: "WES")
    create(:protected_area_parcel, site_id: 123, site_pid: "ABC", name: "Parcel A", countries: [country])
    create(:protected_area_parcel, site_id: 456, site_pid: "XYZ", name: "Parcel B")

    get_with_rabl "/v4/protected_area_parcels/search", {country: "WES"}

    assert last_response.ok?
    assert_equal(1, @json_response["protected_area_parcels"].size)
    assert_equal(123, @json_response["protected_area_parcels"][0]["site_id"])
    assert_equal("ABC", @json_response["protected_area_parcels"][0]["site_pid"])
    assert_equal("Parcel A", @json_response["protected_area_parcels"][0]["name_english"])
  end

  def test_get_protected_area_parcels_search_with_marine_returns_matching_parcels
    create(:protected_area_parcel, site_id: 123, site_pid: "ABC", name: "Parcel A", marine: true)
    create(:protected_area_parcel, site_id: 456, site_pid: "XYZ", name: "Parcel B", marine: false)

    get_with_rabl "/v4/protected_area_parcels/search", {marine: true}

    assert last_response.ok?
    assert_equal(1, @json_response["protected_area_parcels"].size)
    assert_equal(123, @json_response["protected_area_parcels"][0]["site_id"])
    assert_equal("ABC", @json_response["protected_area_parcels"][0]["site_pid"])
    assert_equal("Parcel A", @json_response["protected_area_parcels"][0]["name_english"])
  end

  def test_get_protected_area_parcels_search_wants_at_least_one_param
    get_with_rabl "/v4/protected_area_parcels/search", {}

    refute last_response.ok?
    assert_equal 400, last_response.status
  end

  def test_get_protected_area_parcels_123_returns_parcels_for_site_id_123
    create(:protected_area_parcel, site_id: 123, site_pid: "ABC", name: "Parcel A")
    create(:protected_area_parcel, site_id: 123, site_pid: "DEF", name: "Parcel B")
    create(:protected_area_parcel, site_id: 456, site_pid: "XYZ", name: "Parcel C")

    get_with_rabl "/v4/protected_area_parcels/123"

    assert last_response.ok?
    assert_equal(2, @json_response["protected_area_parcels"].size)
  end

  def test_get_protected_area_parcels_123_returns_404_when_none_exist
    get_with_rabl "/v4/protected_area_parcels/123"

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_area_parcels_123_ABC_returns_single_parcel
    create(:protected_area_parcel, site_id: 123, site_pid: "ABC", name: "Parcel A")
    get_with_rabl "/v4/protected_area_parcels/123/ABC"

    assert last_response.ok?
    assert_equal(123, @json_response["protected_area_parcel"]["site_id"])
    assert_equal("ABC", @json_response["protected_area_parcel"]["site_pid"])
    assert_equal("Parcel A", @json_response["protected_area_parcel"]["name_english"])
  end

  def test_get_protected_area_parcels_123_ABC_returns_404_when_missing
    get_with_rabl "/v4/protected_area_parcels/123/ABC"

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_area_parcels_returns_401_on_wrong_token
    get_with_rabl "/v4/protected_area_parcels", token: "wrong token"

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_area_parcels_returns_401_on_inactive_user
    user = ApiUser.create(token: "thetoken", active: false)
    get_with_rabl "/v4/protected_area_parcels", {token: user.token}

    refute last_response.ok?
    assert_equal 401, last_response.status
  end
end
