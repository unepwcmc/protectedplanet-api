# frozen_string_literal: true

require 'test_helper'
require 'models/protected_area_parcel'

class ProtectedAreaParcelTest < Minitest::Test
  def test_search_with_country_returns_parcel_from_country
    country = create(:country, iso_3: 'WES')
    parcel = create(:protected_area_parcel, countries: [country])

    result = ProtectedAreaParcel.search(country: 'WES')
    assert_equal [parcel.id], result.pluck(:id)
  end

  def test_search_with_marine_returns_marine_parcel
    parcel = create(:protected_area_parcel, marine: true)
    _other = create(:protected_area_parcel, marine: false)

    result = ProtectedAreaParcel.search(marine: true)
    assert_equal [parcel.id], result.pluck(:id)
  end

  def test_search_with_designation_filters_by_designation_id
    des_a = create(:designation, name: 'MP Des A')
    des_b = create(:designation, name: 'MP Des B')
    p_a = create(:protected_area_parcel, designation: des_a)
    create(:protected_area_parcel, designation: des_b)

    result = ProtectedAreaParcel.search(designation: des_a.id)
    assert_equal [p_a.id], result.pluck(:id)
  end

  def test_search_with_jurisdiction_filters_by_designation_jurisdiction
    jur_a = create(:jurisdiction, name: 'MP Jur A')
    jur_b = create(:jurisdiction, name: 'MP Jur B')
    des_a = create(:designation, jurisdiction: jur_a)
    des_b = create(:designation, jurisdiction: jur_b)
    p_a = create(:protected_area_parcel, designation: des_a)
    create(:protected_area_parcel, designation: des_b)

    result = ProtectedAreaParcel.search(jurisdiction: jur_a.id)
    assert_equal [p_a.id], result.pluck(:id)
  end

  def test_search_with_governance_filters_by_governance_id
    gov_a = create(:governance, name: 'MP Gov A')
    gov_b = create(:governance, name: 'MP Gov B')
    p_a = create(:protected_area_parcel, governance: gov_a)
    create(:protected_area_parcel, governance: gov_b)

    result = ProtectedAreaParcel.search(governance: gov_a.id)
    assert_equal [p_a.id], result.pluck(:id)
  end

  def test_search_with_iucn_category_filters_by_iucn_category_id
    cat_a = create(:iucn_category, name: 'MP Cat A')
    cat_b = create(:iucn_category, name: 'MP Cat B')
    p_a = create(:protected_area_parcel, iucn_category: cat_a)
    create(:protected_area_parcel, iucn_category: cat_b)

    result = ProtectedAreaParcel.search(iucn_category: cat_a.id)
    assert_equal [p_a.id], result.pluck(:id)
  end
end
