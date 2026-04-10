# frozen_string_literal: true

# Shape checks mirror GET /v4/protected_areas/:site_id on staging
# (verified 2026-04 against api.new-web.pp-staging.linode.protectedplanet.net, e.g. site_id 1).
module V4ContractHelpers
  SAMPLE_PAME_VALUES = ContractSamples::V4_PAME_EVALUATION
  SAMPLE_PAME_SOURCE_VALUES = ContractSamples::V4_PAME_SOURCE
  SAMPLE_PAME_METHOD_VALUES = ContractSamples::V4_PAME_METHOD
  SAMPLE_GREEN_LIST_VALUES = ContractSamples::V4_GREEN_LIST
  SAMPLE_COUNTRY_VALUES = ContractSamples::SAMPLE_COUNTRY

  PAME_EVALUATION_KEYS = %w[
    eff_metaid asmt_year method asmt_url asmt_id submit_year
    verif_eff info_url gov_act gov_asmt dp_bio dp_other
    mgmt_obset mgmt_obman mgmt_adapt mgmt_staff mgmt_budgt mgmt_thrts mgmt_mon out_bio
    id year url metadata_id methodology source pame_method
  ].freeze

  PAME_SOURCE_KEYS = %w[eff_metaid data_title resp_party year language].freeze

  PAME_METHOD_KEYS = %w[id name].freeze

  PAGINATION_KEYS = %w[page per_page total_pages total_count].freeze

  GREEN_LIST_STATUS_KEYS = %w[
    id gl_status gl_expiry gl_link status expiry_date link
  ].freeze

  COUNTRY_CORE_KEYS = %w[
    name iso_3 id pas_count pas_national_count pas_regional_count pas_international_count
    pas_with_iucn_category_count pas_with_iucn_category_percentage links designations
    iucn_categories governances
  ].freeze

  V4_PROTECTED_AREA_ENVELOPE_NO_GEOM = %w[
    name_english name site_id site_pid international_criteria verif parent_iso3
    gis_marine_area gis_area site_type marine reported_marine_area reported_area
    management_plan is_green_list is_oecm supplementary_info conservation_objectives
    governance_subtype owner_type ownership_subtype inland_waters oecm_assessment
    countries iucn_category designation no_take_status legal_status
    management_authority governance green_list_status sources realm
    protected_area_parcels links legal_status_updated_at pame_evaluations
  ].freeze

  V4_PROTECTED_AREA_ENVELOPE_WITH_GEOM = (V4_PROTECTED_AREA_ENVELOPE_NO_GEOM + %w[geojson]).freeze

  # Parcel list/show in staging (`v4_protected_area_parcels*.json`).
  V4_PROTECTED_AREA_PARCEL_ENVELOPE_NO_GEOM = %w[
    name_english name site_id site_pid international_criteria verif parent_iso3
    gis_marine_area gis_area site_type marine reported_marine_area reported_area
    management_plan is_green_list is_oecm supplementary_info conservation_objectives
    inland_waters oecm_assessment governance_subtype owner_type ownership_subtype
    pame_evaluations countries iucn_category designation no_take_status legal_status
    management_authority governance sources realm green_list_status links legal_status_updated_at
  ].freeze

  V4_PROTECTED_AREA_PARCEL_ENVELOPE_WITH_GEOM = (V4_PROTECTED_AREA_PARCEL_ENVELOPE_NO_GEOM + %w[geojson]).freeze

  def assert_v4_pame_evaluation_shape(evaluation)
    assert_kind_of Hash, evaluation
    missing = PAME_EVALUATION_KEYS - evaluation.keys
    assert_empty missing, "pame_evaluation missing keys: #{missing.inspect}"

    assert_kind_of Hash, evaluation['source']
    src_missing = PAME_SOURCE_KEYS - evaluation['source'].keys
    assert_empty src_missing, "pame source missing keys: #{src_missing.inspect}"
    src_id = evaluation['source']['eff_metaid']
    assert src_id.is_a?(Integer) && src_id > 0,
           'API must include source.eff_metaid (positive integer; serialized pame_sources.id)'

    assert_kind_of Hash, evaluation['pame_method']
    pm_missing = PAME_METHOD_KEYS - evaluation['pame_method'].keys
    assert_empty pm_missing, "pame_method missing keys: #{pm_missing.inspect}"
  end

  def assert_v4_green_list_status_shape(gl)
    assert_kind_of Hash, gl
    missing = GREEN_LIST_STATUS_KEYS - gl.keys
    assert_empty missing, "green_list_status missing keys: #{missing.inspect}"
    assert_equal gl['gl_status'], gl['status']
    assert_equal gl['gl_expiry'], gl['expiry_date']
    assert_equal gl['gl_link'], gl['link']
  end

  def assert_v4_pame_evaluation(evaluation)
    assert_v4_pame_evaluation_shape(evaluation)

    SAMPLE_PAME_VALUES.each do |key, value|
      assert_equal value, evaluation[key], "unexpected pame_evaluation value for #{key}"
    end

    SAMPLE_PAME_SOURCE_VALUES.each do |key, value|
      assert_equal value, evaluation['source'][key], "unexpected source value for #{key}"
    end

    SAMPLE_PAME_METHOD_VALUES.each do |key, value|
      assert_equal value, evaluation['pame_method'][key], "unexpected pame_method value for #{key}"
    end
  end

  def assert_v4_green_list_status(gl)
    SAMPLE_GREEN_LIST_VALUES.each do |key, value|
      assert_equal value, gl[key], "unexpected green_list_status value for #{key}"
    end
    assert_equal gl['gl_status'], gl['status']
    assert_equal gl['gl_expiry'], gl['expiry_date']
    assert_equal gl['gl_link'], gl['link']
  end

  def assert_v4_country_shape(country)
    assert_kind_of Hash, country
    missing = COUNTRY_CORE_KEYS - country.keys
    assert_empty missing, "country missing keys: #{missing.inspect}"
    assert_kind_of Hash, country['links']
    assert_kind_of Array, country['designations']
    assert_kind_of Array, country['iucn_categories']
  end

  def assert_v4_country(country)
    SAMPLE_COUNTRY_VALUES.each do |key, value|
      assert_equal value, country[key], "unexpected country value for #{key}"
    end
  end

  def assert_v4_pagination_shape(pagination)
    assert_kind_of Hash, pagination
    missing = PAGINATION_KEYS - pagination.keys
    assert_empty missing, "pagination missing keys: #{missing.inspect}"
    assert_kind_of Integer, pagination['page']
    assert_kind_of Integer, pagination['per_page']
    assert_kind_of Integer, pagination['total_pages']
    assert_kind_of Integer, pagination['total_count']
  end

  def assert_v4_protected_area_envelope(pa, with_geometry:)
    keys = with_geometry ? V4_PROTECTED_AREA_ENVELOPE_WITH_GEOM : V4_PROTECTED_AREA_ENVELOPE_NO_GEOM
    assert_kind_of Hash, pa
    missing = keys - pa.keys
    assert_empty missing, "protected_area missing keys: #{missing.inspect}"
    assert_kind_of Array, pa['countries']
    assert_kind_of Array, pa['sources']
    assert_kind_of Array, pa['protected_area_parcels']
    assert_kind_of Array, pa['pame_evaluations']
    assert_kind_of Hash, pa['iucn_category']
    assert_kind_of Hash, pa['designation']
    assert_kind_of Hash, pa['designation']['jurisdiction']
    assert_kind_of Hash, pa['no_take_status']
    assert_kind_of Hash, pa['legal_status']
    assert_kind_of Hash, pa['management_authority']
    assert_kind_of Hash, pa['governance']
    assert_kind_of Hash, pa['realm']
    assert pa.has_key?('green_list_status')
    assert_kind_of Hash, pa['links']

    if with_geometry
      assert pa.key?('geojson'), 'geojson key expected when with_geometry is true'
      assert(
        pa['geojson'].nil? || pa['geojson'].is_a?(Hash),
        'geojson must be null or a GeoJSON Feature hash when with_geometry is true'
      )
    else
      refute pa.key?('geojson'), 'geojson must be omitted when with_geometry is false'
    end
  end

  def assert_v4_protected_area_parcel_envelope(pap, with_geometry:)
    keys = with_geometry ? V4_PROTECTED_AREA_PARCEL_ENVELOPE_WITH_GEOM : V4_PROTECTED_AREA_PARCEL_ENVELOPE_NO_GEOM
    assert_kind_of Hash, pap
    missing = keys - pap.keys
    assert_empty missing, "protected_area_parcel missing keys: #{missing.inspect}"

    assert_kind_of Array, pap['countries']
    assert_kind_of Array, pap['sources']
    assert_kind_of Array, pap['pame_evaluations']
    assert_kind_of Hash, pap['iucn_category']
    assert_kind_of Hash, pap['designation']
    assert_kind_of Hash, pap['designation']['jurisdiction']
    assert_kind_of Hash, pap['no_take_status']
    assert_kind_of Hash, pap['legal_status']
    assert_kind_of Hash, pap['management_authority']
    assert_kind_of Hash, pap['governance']
    assert_kind_of Hash, pap['realm']
    assert pap.has_key?('green_list_status')
    assert_kind_of Hash, pap['links']

    if with_geometry
      assert pap.key?('geojson'), 'geojson key expected when with_geometry is true'
      assert(
        pap['geojson'].nil? || pap['geojson'].is_a?(Hash),
        'geojson must be null or a GeoJSON Feature hash when with_geometry is true'
      )
    else
      refute pap.key?('geojson'), 'geojson must be omitted when with_geometry is false'
    end
  end
end
