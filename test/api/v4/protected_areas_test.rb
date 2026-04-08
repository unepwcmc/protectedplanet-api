require 'test_helper'
require 'api/root'

class API::V4::ProtectedAreasTest < Minitest::Test
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

  def test_get_protected_areas_returns_all_protected_areas_as_JSON
    3.times { create(:protected_area) }
    get_json_api '/v4/protected_areas'

    assert last_response.ok?
    assert_equal 3, @json_response['protected_areas'].size
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
    assert_v4_pagination_shape(@json_response['pagination'])
    assert_equal 1, @json_response['pagination']['page']
    assert_equal 25, @json_response['pagination']['per_page']
    assert_equal 1, @json_response['pagination']['total_pages']
    assert_equal 3, @json_response['pagination']['total_count']
  end

  def test_get_protected_areas_second_page_returns_slice
    3.times { create(:protected_area) }
    get_json_api '/v4/protected_areas', { page: 2, per_page: 2 }

    assert last_response.ok?
    assert_equal 1, @json_response['protected_areas'].size
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
    assert_v4_pagination_shape(@json_response['pagination'])
    assert_equal 2, @json_response['pagination']['page']
    assert_equal 2, @json_response['pagination']['per_page']
    assert_equal 2, @json_response['pagination']['total_pages']
    assert_equal 3, @json_response['pagination']['total_count']
  end

  def test_get_protected_areas_rejects_per_page_out_of_range
    get_json_api '/v4/protected_areas', { per_page: 51 }

    refute last_response.ok?
    assert_equal 400, last_response.status
  end

  def test_get_protected_areas_with_geometry_true_returns_all_protected_areas_with_geojson
    3.times { create(:protected_area, the_geom: 'POINT(-122 47)') }
    get_json_api '/v4/protected_areas', { with_geometry: true }

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['protected_areas'][0]['geojson'])
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: true)
  end

  def test_get_protected_areas_123_returns_protected_area_with_site_id_123
    create(:protected_area, name: 'Darjeeling', site_id: 123)
    get_json_api '/v4/protected_areas/123'

    assert last_response.ok?
    assert_equal(123, @json_response['protected_area']['site_id'])
    assert_equal('Darjeeling', @json_response['protected_area']['name_english'])
    assert_v4_protected_area_envelope(@json_response['protected_area'], with_geometry: true)
  end

  def test_get_protected_areas_123_with_geometry_returns_protected_area_123_with_geojson
    create(:protected_area, name: 'Darjeeling', site_id: 123, the_geom: 'POINT(-122 47)')
    get_json_api '/v4/protected_areas/123'

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['protected_area']['geojson'])
    assert_v4_protected_area_envelope(@json_response['protected_area'], with_geometry: true)
  end

  def test_get_protected_areas_999999_returns_404
    get_json_api '/v4/protected_areas/999999'

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_protected_areas_search_with_country_returns_pas_with_country
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    create(:protected_area, site_id: 123, name: 'Darjeeling', countries: [country])
    create(:protected_area, site_id: 456, name: 'From Another Country')

    get_json_api '/v4/protected_areas/search', { country: 'WES' }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
    assert_v4_pagination_shape(@json_response['pagination'])
    assert_equal 1, @json_response['pagination']['total_count']
  end

  def test_get_protected_areas_search_with_country_lowercase_returns_pas_with_country
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    create(:protected_area, site_id: 123, name: 'Darjeeling', countries: [country])
    create(:protected_area, site_id: 456, name: 'From Another Country')

    get_json_api '/v4/protected_areas/search', { country: 'wes' }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_designation_returns_matching_pas
    des_a = create(:designation, name: 'Filter Des A')
    des_b = create(:designation, name: 'Filter Des B')
    create(:protected_area, site_id: 501, name: 'PA A', designation: des_a)
    create(:protected_area, site_id: 502, name: 'PA B', designation: des_b)

    get_json_api '/v4/protected_areas/search', { designation: des_a.id }

    assert last_response.ok?
    assert_equal 1, @json_response['protected_areas'].size
    assert_equal 501, @json_response['protected_areas'][0]['site_id']
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_jurisdiction_returns_matching_pas
    jur_a = create(:jurisdiction, name: 'Jur Search A')
    jur_b = create(:jurisdiction, name: 'Jur Search B')
    des_a = create(:designation, name: 'Des Jur A', jurisdiction: jur_a)
    des_b = create(:designation, name: 'Des Jur B', jurisdiction: jur_b)
    create(:protected_area, site_id: 601, designation: des_a)
    create(:protected_area, site_id: 602, designation: des_b)

    get_json_api '/v4/protected_areas/search', { jurisdiction: jur_a.id }

    assert last_response.ok?
    assert_equal 1, @json_response['protected_areas'].size
    assert_equal 601, @json_response['protected_areas'][0]['site_id']
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_governance_returns_matching_pas
    gov_a = create(:governance, name: 'Gov Search A')
    gov_b = create(:governance, name: 'Gov Search B')
    create(:protected_area, site_id: 701, governance: gov_a)
    create(:protected_area, site_id: 702, governance: gov_b)

    get_json_api '/v4/protected_areas/search', { governance: gov_a.id }

    assert last_response.ok?
    assert_equal 1, @json_response['protected_areas'].size
    assert_equal 701, @json_response['protected_areas'][0]['site_id']
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_iucn_category_returns_matching_pas
    cat_a = create(:iucn_category, name: 'Cat A')
    cat_b = create(:iucn_category, name: 'Cat B')
    create(:protected_area, site_id: 801, iucn_category: cat_a)
    create(:protected_area, site_id: 802, iucn_category: cat_b)

    get_json_api '/v4/protected_areas/search', { iucn_category: cat_a.id }

    assert last_response.ok?
    assert_equal 1, @json_response['protected_areas'].size
    assert_equal 801, @json_response['protected_areas'][0]['site_id']
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_marine_returns_marine_pas
    create(:protected_area, site_id: 123, name: 'Darjeeling', marine: true)
    create(:protected_area, site_id: 456, name: 'Not Marine', marine: false)

    get_json_api '/v4/protected_areas/search', { marine: true }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_equal('Darjeeling', @json_response['protected_areas'][0]['name_english'])
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_with_is_green_list_returns_green_listed_pas
    green_list_status = GreenListStatus.create!(ContractSamples::GREEN_LIST_STATUS_ATTRIBUTES)
    create(:protected_area, site_id: 123, name: 'Darjeeling', green_list_status: green_list_status)
    create(:protected_area, site_id: 456, name: 'Not Green', green_list_status_id: nil)

    get_json_api '/v4/protected_areas/search', { is_green_list: true }

    assert last_response.ok?
    assert_equal(1, @json_response['protected_areas'].size)
    assert_equal(123, @json_response['protected_areas'][0]['site_id'])
    assert_v4_green_list_status_shape(@json_response['protected_areas'][0]['green_list_status'])
    assert_v4_green_list_status(@json_response['protected_areas'][0]['green_list_status'])
    assert_v4_protected_area_envelope(@json_response['protected_areas'].first, with_geometry: false)
  end

  def test_get_protected_areas_search_wants_at_least_one_param
    get_json_api '/v4/protected_areas/search', {}

    refute last_response.ok?
    assert_equal 400, last_response.status
  end

  def test_get_protected_areas_biopama_returns_only_acp_countries_areas_with_pame_evaluations
    create(:protected_area, :biopama_country, name: 'Mandalia Plains')
    create(:protected_area, :biopama_country, :with_pame_evaluation, name: 'Darjeeling')
    create(:protected_area, :biopama_country, :with_pame_evaluation, name: 'Not Marine')

    get_json_api '/v4/protected_areas/biopama'

    assert last_response.ok?
    assert_equal(2, @json_response['protected_areas'].size)
    @json_response['protected_areas'].each do |pa|
      assert_v4_protected_area_envelope(pa, with_geometry: false)
      refute_empty pa['pame_evaluations'], 'expected PAME data (biopama scope)'
      assert_v4_pame_evaluation_shape(pa['pame_evaluations'].first)
    end
    refute @json_response.key?('pagination')
  end

  def test_get_protected_areas_returns_401_on_wrong_token
    get_json_api '/v4/protected_areas', token: 'wrong token'

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_areas_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_json_api '/v4/protected_areas', { token: user.token }

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_protected_area_pame_evaluation_json_matches_v4_contract
    pa = create(:protected_area, site_id: 9100)
    create(:pame_evaluation, protected_area: pa, asmt_id: 11_516)

    get_json_api '/v4/protected_areas/9100', { with_geometry: false }
    assert last_response.ok?

    list = @json_response['protected_area']['pame_evaluations']
    assert_equal 1, list.size
    assert_v4_pame_evaluation(list.first)
    assert_equal 11_516, list.first['asmt_id']
    assert_equal 11_516, list.first['id']
    assert_equal list.first['metadata_id'], list.first['eff_metaid']
    assert_equal list.first['year'], list.first['asmt_year']
    assert_equal list.first['methodology'], list.first['method']
    assert_v4_protected_area_envelope(@json_response['protected_area'], with_geometry: false)
  end

  def test_get_protected_area_green_list_status_includes_gl_fields_and_v4_aliases
    gl = GreenListStatus.create!(ContractSamples::GREEN_LIST_STATUS_ATTRIBUTES)
    create(:protected_area, site_id: 9101, green_list_status: gl)

    get_json_api '/v4/protected_areas/9101', { with_geometry: false }
    assert last_response.ok?

    assert @json_response['protected_area']['is_green_list']
    status = @json_response['protected_area']['green_list_status']
    assert_v4_green_list_status_shape(status)
    assert_v4_green_list_status(status)
    assert_v4_protected_area_envelope(@json_response['protected_area'], with_geometry: false)
  end

  def test_get_protected_area_merges_pame_evaluations_from_site_and_parcels
    pa = create(:protected_area, site_id: 9102)
    parcel = create(:protected_area_parcel, site_id: 9102, site_pid: 'P9102A', name: 'Parcel A')
    create(:pame_evaluation, protected_area: pa, asmt_id: 11_517)
    create(:pame_evaluation, protected_area: nil, protected_area_parcel: parcel, asmt_id: 11_518)

    get_json_api '/v4/protected_areas/9102', { with_geometry: false }
    assert last_response.ok?

    pames = @json_response['protected_area']['pame_evaluations']
    assert_equal 2, pames.size
    pames.each { |pe| assert_v4_pame_evaluation_shape(pe) }
    assert_v4_protected_area_envelope(@json_response['protected_area'], with_geometry: false)
  end

  def test_get_protected_area_26630_style_payload_has_empty_green_list_pame_and_parcels
    create(:protected_area, site_id: 26_630, name: 'Sample No PAME')

    get_json_api '/v4/protected_areas/26630', { with_geometry: false }
    assert last_response.ok?

    pa = @json_response['protected_area']
    refute pa['is_green_list']
    assert_nil pa['green_list_status']
    assert_equal [], pa['pame_evaluations']
    assert_equal [], pa['protected_area_parcels']
    assert_v4_protected_area_envelope(pa, with_geometry: false)
  end
end
