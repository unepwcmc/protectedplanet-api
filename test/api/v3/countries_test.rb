require 'test_helper'
require 'api/root'

class API::V3::CountriesTest < Minitest::Test
  include Rack::Test::Methods
  include V3ContractHelpers

  EXPECTED_GEOJSON = {
    'type' => 'Feature',
    'properties' => { 'fill-opacity' => 0.7, 'stroke-width' => 0.05, 'stroke' => '#40541b', 'fill' => '#83ad35',
                      'marker-color' => '#2B3146' },
    'geometry' => { 'type' => 'Point', 'coordinates' => [-122, 47] }
  }

  def app
    API::Root
  end

  def test_get_countries_returns_all_countries_as_JSON
    3.times { create(:country) }
    get_json_api '/v3/countries'

    assert last_response.ok?
    assert_equal 3, @json_response['countries'].size
  end

  def test_get_countries_second_page_returns_slice
    3.times { create(:country) }
    get_json_api '/v3/countries', { page: 2, per_page: 2 }

    assert last_response.ok?
    assert_equal 1, @json_response['countries'].size
  end

  def test_get_countries_rejects_per_page_out_of_range
    get_json_api '/v3/countries', { per_page: 51 }

    refute last_response.ok?
    assert_error_response(400)
  end

  def test_get_countries_page_below_one_returns_empty_slice
    get_json_api '/v3/countries', { page: 0 }

    assert last_response.ok?
    assert_equal 0, @json_response['countries'].size
  end

  def test_get_countries_rejects_per_page_below_one
    get_json_api '/v3/countries', { per_page: 0 }

    refute last_response.ok?
    assert_error_response(400)
  end

  def test_get_countries_rejects_non_integer_page
    get_json_api '/v3/countries', { page: 'x' }

    refute last_response.ok?
    assert_error_response(400)
  end

  def test_get_countries_with_geometry_true_returns_all_countries_with_geojson
    3.times { create(:country, bounding_box: 'POINT(-122 47)') }
    get_json_api '/v3/countries', { with_geometry: true }

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['countries'][0]['geojson'])
  end

  def test_get_countries_WES_returns_country_with_iso_3_WES
    create(:country, name: 'Zubrowka', iso_3: 'WES')
    get_json_api '/v3/countries/WES'

    assert last_response.ok?
    assert_equal('WES', @json_response['country']['id'])
    assert_equal('WES', @json_response['country']['iso_3'])
    assert_equal('Zubrowka', @json_response['country']['name'])
    assert_equal 'WES', @json_response['country']['id']
  end

  def test_get_countries_wes_returns_country_with_iso_3_WES
    create(:country, name: 'Zubrowka', iso_3: 'WES')
    get_json_api '/v3/countries/wes'

    assert last_response.ok?
    assert_equal('WES', @json_response['country']['id'])
    assert_equal('WES', @json_response['country']['iso_3'])
    assert_equal('Zubrowka', @json_response['country']['name'])
  end

  def test_get_countries_GB_returns_country_resolved_via_iso2
    create(:country, name: 'United Kingdom', iso: 'GB', iso_3: 'GBR')
    get_json_api '/v3/countries/GB'

    assert last_response.ok?
    assert_equal('GBR', @json_response['country']['id'])
    assert_equal('GBR', @json_response['country']['iso_3'])
    assert_equal('United Kingdom', @json_response['country']['name'])
  end

  def test_get_countries_WES_with_geometry_returns_country_WES_with_geojson
    create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    get_json_api '/v3/countries/WES'

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['country']['geojson'])
  end

  def test_get_countries_unknown_returns_404
    get_json_api '/v3/countries/ZZZ'

    refute last_response.ok?
    assert_error_response(404)
  end

  def test_get_countries_WES_returns_designations_with_counts
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    jurisdiction = create(:jurisdiction, name: 'National')
    designation = create(:designation, name: 'National Hotel', jurisdiction: jurisdiction)
    create(:protected_area, name: 'Grand Budapest', countries: [country], designation: designation)

    get_json_api '/v3/countries/wes'

    assert last_response.ok?
    assert_equal([{
                   'id' => designation.id,
                   'name' => 'National Hotel',
                   'jurisdiction' => { 'id' => jurisdiction.id, 'name' => 'National' },
                   'pas_count' => 1
                 }], @json_response['country']['designations'])
  end

  def test_get_countries_WES_returns_iucn_categories_with_counts
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    iucn_category = create(:iucn_category, name: 'IV')
    create(:protected_area, name: 'Grand Budapest', countries: [country], iucn_category: iucn_category)

    get_json_api '/v3/countries/wes'

    assert last_response.ok?
    assert_equal([{
                   'id' => iucn_category.id,
                   'name' => 'IV',
                   'pas_count' => 1,
                   'pas_percentage' => 100
                 }], @json_response['country']['iucn_categories'])
  end

  def test_get_countries_WES_returns_governances_with_counts
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    governance = create(:governance, name: 'Joint governance')
    create(:protected_area, name: 'Grand Budapest', countries: [country], governance: governance)

    get_json_api '/v3/countries/wes'

    assert last_response.ok?
    assert_equal([{
                   'id' => governance.id,
                   'name' => 'Joint governance',
                   'governance_type' => 'Shared Governance',
                   'pas_count' => 1,
                   'pas_percentage' => 100
                 }], @json_response['country']['governances'])
  end

  def test_get_country_returns_grouped_governances
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    governance = create(:governance, name: 'Joint governance')
    create(:protected_area, name: 'Grand Budapest', countries: [country], governance: governance)

    get_json_api '/v3/countries/wes', group_governances: true

    assert last_response.ok?
    assert_equal({
                   'Shared Governance' => [{
                     'id' => governance.id,
                     'name' => 'Joint governance',
                     'governance_type' => 'Shared Governance',
                     'pas_count' => 1,
                     'pas_percentage' => 100
                   }]
                 }, @json_response['country']['governances'])
  end

  def test_get_countries_WES_returns_pas_count
    country = create(:country, name: 'Zubrowka', iso_3: 'WES')
    iucn_category = create(:iucn_category, name: 'IV')
    create(:protected_area, name: 'Grand Budapest', countries: [country], iucn_category: nil)
    create(:protected_area, name: 'Mistery Shack', countries: [country], iucn_category: iucn_category)
    get_json_api '/v3/countries/WES'

    assert last_response.ok?
    assert_equal('WES', @json_response['country']['id'])
    assert_equal(2, @json_response['country']['pas_count'])
    assert_equal(1, @json_response['country']['pas_with_iucn_category_count'])
    assert_equal(50.0, @json_response['country']['pas_with_iucn_category_percentage'])
  end

  def test_get_country_WES_returns_iucn_categories_with_long_names
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    iucn_category = create(:iucn_category, name: 'IV')
    create(:protected_area, name: 'Grand Budapest', countries: [country], iucn_category: iucn_category)

    get_json_api '/v3/countries/wes', iucn_category_long_names: true

    assert last_response.ok?
    assert_equal([{
                   'id' => iucn_category.id,
                   'name' => 'IV - Habitat/Species Management Area',
                   'pas_count' => 1,
                   'pas_percentage' => 100
                 }], @json_response['country']['iucn_categories'])
  end

  def test_get_countries_returns_401_on_wrong_token
    get_json_api '/v3/countries', token: 'wrong token'

    refute last_response.ok?
    assert_error_response(401)
  end

  def test_get_countries_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_json_api '/v3/countries', { token: user.token }

    refute last_response.ok?
    assert_error_response(401)
  end
end
