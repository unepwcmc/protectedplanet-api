require 'test_helper'
require 'models/protected_area'

class ProtectedAreaTest < Minitest::Test
  def test_search_with_country_returns_pa_from_country
    country = create(:country, iso_3: 'WES')
    pa = create(:protected_area, countries: [country])

    result = ProtectedArea.search(country: 'WES')
    assert_equal [pa], result
  end

  def test_search_with_marine_returns_marine_pa
    pa = create(:protected_area, marine: true)
    _non_marine_pa = create(:protected_area, marine: false)

    result = ProtectedArea.search(marine: true)
    assert_equal [pa], result
  end

  def test_search_with_designation_filters_by_designation_id
    des_a = create(:designation, name: 'M Des A')
    des_b = create(:designation, name: 'M Des B')
    pa_a = create(:protected_area, designation: des_a)
    create(:protected_area, designation: des_b)

    result = ProtectedArea.search(designation: des_a.id)
    assert_equal [pa_a.id], result.pluck(:id)
  end

  def test_search_with_jurisdiction_filters_by_designation_jurisdiction
    jur_a = create(:jurisdiction, name: 'M Jur A')
    jur_b = create(:jurisdiction, name: 'M Jur B')
    des_a = create(:designation, jurisdiction: jur_a)
    des_b = create(:designation, jurisdiction: jur_b)
    pa_a = create(:protected_area, designation: des_a)
    create(:protected_area, designation: des_b)

    result = ProtectedArea.search(jurisdiction: jur_a.id)
    assert_equal [pa_a.id], result.pluck(:id)
  end

  def test_search_with_governance_filters_by_governance_id
    gov_a = create(:governance, name: 'M Gov A')
    gov_b = create(:governance, name: 'M Gov B')
    pa_a = create(:protected_area, governance: gov_a)
    create(:protected_area, governance: gov_b)

    result = ProtectedArea.search(governance: gov_a.id)
    assert_equal [pa_a.id], result.pluck(:id)
  end

  def test_search_with_iucn_category_filters_by_iucn_category_id
    cat_a = create(:iucn_category, name: 'M Cat A')
    cat_b = create(:iucn_category, name: 'M Cat B')
    pa_a = create(:protected_area, iucn_category: cat_a)
    create(:protected_area, iucn_category: cat_b)

    result = ProtectedArea.search(iucn_category: cat_a.id)
    assert_equal [pa_a.id], result.pluck(:id)
  end
end
