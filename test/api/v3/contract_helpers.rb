# frozen_string_literal: true

module V3ContractHelpers
  V3_PROTECTED_AREA_ENVELOPE_NO_GEOM = %w[
    conservation_objectives countries designation governance gis_area gis_marine_area
    green_list_status id international_criteria is_green_list is_oecm
    iucn_category legal_status legal_status_updated_at links management_authority
    management_plan marine marine_type name no_take_status original_name owner_type
    pame_evaluations parent_iso3 reported_area reported_marine_area sources sub_locations
    supplementary_info verif wdpa_id wdpa_pid
  ].freeze

  V3_PROTECTED_AREA_ENVELOPE_WITH_GEOM = (V3_PROTECTED_AREA_ENVELOPE_NO_GEOM + %w[geojson]).freeze

  V3_PROTECTED_AREA_COUNTRY_KEYS = %w[name iso_3 id].freeze
  V3_PROTECTED_AREA_SOURCE_ITEM_KEYS = %w[id title responsible_party year_updated].freeze

  V3_PAME_EVALUATION_KEYS = %w[id url metadata_id methodology source].freeze
  V3_PAME_SOURCE_KEYS = %w[data_title resp_party year language].freeze
  V3_GREEN_LIST_STATUS_KEYS = %w[id status expiry_date link].freeze

  V3_PAME_VALUES = ContractSamples::V3_PAME_EVALUATION
  V3_PAME_SOURCE_VALUES = ContractSamples::V3_PAME_SOURCE
  V3_GREEN_LIST_VALUES = ContractSamples::V3_GREEN_LIST

  def assert_v3_pame_evaluation_shape(evaluation)
    assert_kind_of Hash, evaluation
    missing = V3_PAME_EVALUATION_KEYS - evaluation.keys
    assert_empty missing, "v3 pame missing keys: #{missing.inspect}"

    assert_kind_of Hash, evaluation["source"]
    src_missing = V3_PAME_SOURCE_KEYS - evaluation["source"].keys
    assert_empty src_missing, "v3 pame source missing keys: #{src_missing.inspect}"
  end

  def assert_v3_pame_evaluation(evaluation)
    V3_PAME_VALUES.each do |key, value|
      assert_equal value, evaluation[key], "unexpected v3 pame value for #{key}"
    end
    V3_PAME_SOURCE_VALUES.each do |key, value|
      assert_equal value, evaluation["source"][key], "unexpected v3 source value for #{key}"
    end
  end

  def assert_v3_green_list_status_shape(gl)
    assert_kind_of Hash, gl
    missing = V3_GREEN_LIST_STATUS_KEYS - gl.keys
    assert_empty missing, "v3 green list missing keys: #{missing.inspect}"
  end

  def assert_v3_green_list_status(gl)
    V3_GREEN_LIST_VALUES.each do |key, value|
      assert_equal value, gl[key], "unexpected v3 green list value for #{key}"
    end
  end

  def assert_v3_protected_area_envelope(pa, with_geometry:)
    keys = with_geometry ? V3_PROTECTED_AREA_ENVELOPE_WITH_GEOM : V3_PROTECTED_AREA_ENVELOPE_NO_GEOM
    assert_kind_of Hash, pa
    missing = keys - pa.keys
    assert_empty missing, "v3 protected_area missing keys: #{missing.inspect}"

    pa["countries"].each do |c|
      assert_kind_of Hash, c
      cm = V3_PROTECTED_AREA_COUNTRY_KEYS - c.keys
      assert_empty cm, "v3 country missing keys: #{cm.inspect}"
    end

    pa["sources"].each do |s|
      assert_kind_of Hash, s
      sm = V3_PROTECTED_AREA_SOURCE_ITEM_KEYS - s.keys
      assert_empty sm, "v3 source missing keys: #{sm.inspect}"
    end

    assert_kind_of Array, pa["sub_locations"]
    assert_kind_of Array, pa["pame_evaluations"]
    assert_kind_of Hash, pa["iucn_category"]
    assert_kind_of Hash, pa["designation"]
    assert_kind_of Hash, pa["designation"]["jurisdiction"]
    assert_kind_of Hash, pa["no_take_status"]
    assert_kind_of Hash, pa["legal_status"]
    assert_kind_of Hash, pa["management_authority"]
    assert_kind_of Hash, pa["governance"]
    assert pa.key?("green_list_status")
    if pa["green_list_status"].is_a?(Hash)
      assert_v3_green_list_status_shape(pa["green_list_status"])
    end
    assert_kind_of Hash, pa["links"]

    if with_geometry
      assert pa.key?("geojson"), "geojson key expected when with_geometry is true"
      assert(
        pa["geojson"].nil? || pa["geojson"].is_a?(Hash),
        "geojson must be null or a GeoJSON Feature hash when with_geometry is true"
      )
    else
      refute pa.key?("geojson"), "geojson must be omitted when with_geometry is false"
    end
  end
end
