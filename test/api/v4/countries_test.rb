require 'test_helper'
require 'api/root'

class API::V4::CountriesTest < Minitest::Test
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

  def test_get_countries_returns_all_countries_as_JSON
    3.times { create(:country) }
    get_with_rabl '/v4/countries'

    assert last_response.ok?
    assert_equal 3, @json_response['countries'].size
  end

  def test_get_countries_with_geometry_true_returns_all_countries_with_geojson
    3.times { create(:country, bounding_box: 'POINT(-122 47)') }
    get_with_rabl '/v4/countries', { with_geometry: true }

    assert last_response.ok?
    assert_equal(EXPECTED_GEOJSON, @json_response['countries'][0]['geojson'])
  end

  def test_get_countries_USA_returns_country_with_iso_3_USA
    create(:country, name: 'United States', iso: 'US', iso_3: 'USA')
    get_with_rabl '/v4/countries/USA'

    assert last_response.ok?
    assert_equal('USA', @json_response['country']['id'])
    assert_equal('USA', @json_response['country']['iso_3'])
    assert_equal('United States', @json_response['country']['name'])
    assert_v4_country_shape(@json_response['country'])
  end

  def test_get_countries_usa_returns_country_with_iso_3_USA
    create(:country, name: 'United States', iso: 'US', iso_3: 'USA')
    get_with_rabl '/v4/countries/usa'

    assert last_response.ok?
    assert_equal('USA', @json_response['country']['id'])
    assert_equal('USA', @json_response['country']['iso_3'])
    assert_equal('United States', @json_response['country']['name'])
  end

  def test_get_countries_GB_returns_country_with_iso_GB
    create(:country, name: 'United Kingdom', iso: 'GB', iso_3: 'GBR')
    get_with_rabl '/v4/countries/GB'

    assert last_response.ok?
    assert_equal('GBR', @json_response['country']['id'])
    assert_equal('GBR', @json_response['country']['iso_3'])
    assert_equal('United Kingdom', @json_response['country']['name'])
  end

  def test_get_countries_unknown_returns_404
    get_with_rabl '/v4/countries/ZZZ'

    refute last_response.ok?
    assert_equal 404, last_response.status
  end

  def test_get_country_returns_iucn_categories_with_long_names
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    iucn_category = create(:iucn_category, name: 'IV')
    create(:protected_area, name: 'Grand Budapest', countries: [country], iucn_category: iucn_category)

    get_with_rabl '/v4/countries/wes', iucn_category_long_names: true

    assert last_response.ok?
    assert_equal([{
                   'id' => iucn_category.id,
                   'name' => 'IV - Habitat/Species Management Area',
                   'pas_count' => 1,
                   'pas_percentage' => 100
                 }], @json_response['country']['iucn_categories'])
  end

  def test_get_country_returns_grouped_governances
    country = create(:country, name: 'Zubrowka', iso_3: 'WES', bounding_box: 'POINT(-122 47)')
    governance = create(:governance, name: 'Joint governance')
    create(:protected_area, name: 'Grand Budapest', countries: [country], governance: governance)

    get_with_rabl '/v4/countries/wes', group_governances: true

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

  def test_get_countries_returns_401_on_wrong_token
    get_with_rabl '/v4/countries', token: 'wrong token'

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_countries_returns_401_on_inactive_user
    user = ApiUser.create(token: 'thetoken', active: false)
    get_with_rabl '/v4/countries', { token: user.token }

    refute last_response.ok?
    assert_equal 401, last_response.status
  end

  def test_get_country_matches_truth_for_core_identity_fields
    sample = ContractSamples::SAMPLE_COUNTRY
    create(:country, name: sample['name'], iso: 'AG', iso_3: sample['iso_3'], bounding_box: 'POINT(-122 47)')

    get_with_rabl "/v4/countries/#{sample['id']}", { with_geometry: false }
    assert last_response.ok?

    country = @json_response['country']
    assert_v4_country_shape(country)
    assert_v4_country(country)
  end
end
