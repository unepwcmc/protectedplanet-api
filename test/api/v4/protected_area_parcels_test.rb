require 'test_helper'
require 'api/root'

class API::V4::ProtectedAreaParcelsTest < Minitest::Test
  include Rack::Test::Methods
  include V4ContractHelpers

  EXPECTED_GEOJSON = {
    'type' => 'Feature',
    'properties' => { 'fill-opacity' => 0.7, 'stroke-width' => 0.05, 'stroke' => '#40541b', 'fill' => '#83ad35',
                      'marker-color' => '#2B3146' },
    'geometry' => { 'type' => 'Point', 'coordinates' => [-122, 47] }
  }

  def app
    API::Root
  end

  def test_get_protected_area_parcels_returns_all_protected_area_parcels_as_JSON
    3.times { create(:protected_area_parcel) }
    get_with_rabl '/v4/protected_area_parcels'

    assert last_response.ok?
    assert_equal 3, @json_response['protected_area_parcels'].size
    assert_v4_protected_area_parcel_envelope(@json_response['protected_area_parcels'].first, with_geometry: false)
  end

  def test_get_protected_area_parcels_with_geometry_true_returns_all_protected_area_parcels_with_geojson
    3.times { create(:protected_area_parcel, the_geom: 'POINT(-122 47)') }
    get_with_rabl '/v4/protected_area_parcels', { with_geometry: true }

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['protected_area_parcels'][0]['geojson'])
    assert_v4_protected_area_parcel_envelope(@json_response['protected_area_parcels'].first, with_geometry: true)
  end

  def test_get_protected_area_parcels_search_with_country_returns_matching_parcels
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    create(:protected_area_parcel, site_id: 123, site_pid: 'ABC', name: 'Parcel A', countries: [country])
    create(:protected_area_parcel, site_id: 456, site_pid: 'XYZ', name: 'Parcel B')

    get_with_rabl '/v4/protected_area_parcels/search', { country: 'WES' }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_area_parcels'].size)
    assert_equal(123, @json_response['protected_area_parcels'][0]['site_id'])
    assert_equal('ABC', @json_response['protected_area_parcels'][0]['site_pid'])
    assert_equal('Parcel A', @json_response['protected_area_parcels'][0]['name_english'])
    assert_v4_protected_area_parcel_envelope(@json_response['protected_area_parcels'].first, with_geometry: false)
  end

  def test_get_protected_area_parcels_search_with_marine_returns_matching_parcels
    create(:protected_area_parcel, site_id: 123, site_pid: 'ABC', name: 'Parcel A', marine: true)
    create(:protected_area_parcel, site_id: 456, site_pid: 'XYZ', name: 'Parcel B', marine: false)

    get_with_rabl '/v4/protected_area_parcels/search', { marine: true }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_area_parcels'].size)
    assert_equal(123, @json_response['protected_area_parcels'][0]['site_id'])
    assert_equal('ABC', @json_response['protected_area_parcels'][0]['site_pid'])
    assert_equal('Parcel A', @json_response['protected_area_parcels'][0]['name_english'])
    assert_v4_protected_area_parcel_envelope(@json_response['protected_area_parcels'].first, with_geometry: false)
  end

  def test_get_protected_area_parcels_search_wants_at_least_one_param
    get_with_rabl '/v4/protected_area_parcels/search', {}

    refute last_response.ok?
    assert_equal 400, last_response.status
  end

  def test_get_protected_area_parcels_123_returns_parcels_for_site_id_123
    create(:protected_area_parcel, site_id: 123, site_pid: 'ABC', name: 'Parcel A')
    create(:protected_area_parcel, site_id: 123, site_pid: 'DEF', name: 'Parcel B')
    create(:protected_area_parcel, site_id: 456, site_pid: 'XYZ', name: 'Parcel C')

    get_with_rabl '/v4/protected_area_parcels/123'

    assert last_response.ok?
    assert_equal(2, @json_response['protected_area_parcels'].size)
    @json_response['protected_area_parcels'].each do |pap|
      assert_v4_protected_area_parcel_envelope(pap, with_geometry: true)
    end
  end

  def test_get_protected_area_parcels_123_returns_404_when_none_exist
    get_with_rabl '/v4/protected_area_parcels/123'

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_area_parcels_123_ABC_returns_single_parcel
    create(:protected_area_parcel, site_id: 123, site_pid: 'ABC', name: 'Parcel A')
    get_with_rabl '/v4/protected_area_parcels/123/ABC'

    assert last_response.ok?
    assert_equal(123, @json_response['protected_area_parcel']['site_id'])
    assert_equal('ABC', @json_response['protected_area_parcel']['site_pid'])
    assert_equal('Parcel A', @json_response['protected_area_parcel']['name_english'])
    assert_v4_protected_area_parcel_envelope(@json_response['protected_area_parcel'], with_geometry: true)
  end

  def test_get_protected_area_parcels_123_ABC_returns_404_when_missing
    get_with_rabl '/v4/protected_area_parcels/123/ABC'

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_area_parcels_returns_401_on_wrong_token
    get_with_rabl '/v4/protected_area_parcels', token: 'wrong token'

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_area_parcels_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_with_rabl '/v4/protected_area_parcels', { token: user.token }

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_area_parcel_includes_pame_and_green_list_shapes
    gl = GreenListStatus.create!(ContractSamples::GREEN_LIST_STATUS_ATTRIBUTES)
    parcel = create(
      :protected_area_parcel,
      site_id: 9200,
      site_pid: 'P9200',
      name: 'GL parcel',
      green_list_status: gl
    )
    create(:pame_evaluation, protected_area: nil, protected_area_parcel: parcel, asmt_id: 11_519)

    get_with_rabl '/v4/protected_area_parcels/9200/P9200', { with_geometry: false }
    assert last_response.ok?

    pap = @json_response['protected_area_parcel']
    assert pap['is_green_list']
    assert_v4_green_list_status_shape(pap['green_list_status'])
    assert_v4_green_list_status(pap['green_list_status'])

    assert_equal 1, pap['pame_evaluations'].size
    assert_v4_pame_evaluation(pap['pame_evaluations'].first)
    assert_equal 11_519, pap['pame_evaluations'].first['asmt_id']
    assert_v4_protected_area_parcel_envelope(pap, with_geometry: false)
  end

  def test_get_protected_area_parcel_611_2_style_payload_has_expected_core_values
    create(
      :protected_area_parcel,
      site_id: 611,
      site_pid: '611_2',
      name: 'Wood Buffalo National Park Of Canada',
      marine: false
    )

    get_with_rabl '/v4/protected_area_parcels/611/611_2', { with_geometry: false }
    assert last_response.ok?

    pap = @json_response['protected_area_parcel']
    assert_equal 'Wood Buffalo National Park Of Canada', pap['name_english']
    assert_equal 611, pap['site_id']
    assert_equal '611_2', pap['site_pid']
    refute pap['is_green_list']
    assert_equal [], pap['pame_evaluations']
    assert_v4_protected_area_parcel_envelope(pap, with_geometry: false)
  end
end
