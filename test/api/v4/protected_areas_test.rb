require 'test_helper'
require 'api/root'

class API::V4::ProtectedAreasTest < MiniTest::Test
  include Rack::Test::Methods

  EXPECTED_GEOJSON = {
    'type' => 'Feature',
    'properties' => { 'fill-opacity' => 0.7, 'stroke-width' => 0.05, 'stroke' => '#40541b', 'fill' => '#83ad35',
                      'marker-color' => '#2B3146' },
    'geometry' => { 'type' => 'Point', 'coordinates' => [-122, 47] }
  }

  def app
    API::Root
  end

  def test_get_protected_areas_returns_all_protected_areas_as_JSON
    3.times { create(:protected_area) }
    get_with_rabl '/v4/protected_areas'

    assert last_response.ok?
    assert_equal 3, @json_response['protected_areas'].size
  end

  def test_get_protected_areas_with_geometry_true_returns_all_protected_areas_with_geojson
    3.times { create(:protected_area, the_geom: 'POINT(-122 47)') }
    get_with_rabl '/v4/protected_areas', { with_geometry: true }

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['protected_areas'][0]['geojson'])
  end

  def test_get_protected_areas_123_returns_protected_area_with_site_id_123
    create(:protected_area, name: 'Darjeeling', site_id: 123)
    get_with_rabl '/v4/protected_areas/123'

    assert last_response.ok?
    assert_equal(123, @json_response['protected_area']['site_id'])
    assert_equal('Darjeeling', @json_response['protected_area']['name_english'])
  end

  def test_get_protected_areas_123_with_geometry_returns_protected_area_123_with_geojson
    create(:protected_area, name: 'Darjeeling', site_id: 123, the_geom: 'POINT(-122 47)')
    get_with_rabl '/v4/protected_areas/123'

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['protected_area']['geojson'])
  end

  def test_get_protected_areas_999999_returns_404
    get_with_rabl '/v4/protected_areas/999999'

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_areas_search_with_country_returns_pas_with_country
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    create(:protected_area, site_id: 123, name: 'Darjeeling', countries: [country])
    create(:protected_area, site_id: 456, name: 'From Another Country')

    get_with_rabl '/v4/protected_areas/search', { country: 'WES' }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
  end

  def test_get_protected_areas_search_with_country_lowercase_returns_pas_with_country
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    create(:protected_area, site_id: 123, name: 'Darjeeling', countries: [country])
    create(:protected_area, site_id: 456, name: 'From Another Country')

    get_with_rabl '/v4/protected_areas/search', { country: 'wes' }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
  end

  def test_get_protected_areas_search_with_marine_returns_marine_pas
    create(:protected_area, site_id: 123, name: 'Darjeeling', marine: true)
    create(:protected_area, site_id: 456, name: 'Not Marine', marine: false)

    get_with_rabl '/v4/protected_areas/search', { marine: true }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
  end

  def test_get_protected_areas_search_wants_at_least_one_param
    get_with_rabl '/v4/protected_areas/search', {}

    refute last_response.ok?
    assert_equal 400, last_response.status
  end

  def test_get_protected_areas_biopama_returns_only_acp_countries_areas_with_pame_evaluations
    create(:protected_area, :biopama_country, name: 'Mandalia Plains')
    create(:protected_area, :biopama_country, :with_pame_evaluation, name: 'Darjeeling')
    create(:protected_area, :biopama_country, :with_pame_evaluation, name: 'Not Marine')

    get_with_rabl '/v4/protected_areas/biopama'

    assert last_response.ok?
    assert_equal(2, @json_response['protected_areas'].size)
  end

  def test_get_protected_areas_returns_401_on_wrong_token
    get_with_rabl '/v4/protected_areas', token: 'wrong token'

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_areas_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_with_rabl '/v4/protected_areas', { token: user.token }

    refute last_response.ok?
    assert_equal 401, last_response.status
  end
end
