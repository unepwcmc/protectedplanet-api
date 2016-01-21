require 'test_helper'
require 'models/protected_area'

class ProtectedAreaTest < MiniTest::Test
  def test_search_with_country_returns_pa_from_country
    country = create(:country, iso_3: "WES")
    pa = create(:protected_area, countries: [country])

    result = ProtectedArea.search(country: "WES")
    assert_equal [pa], result
  end

  def test_search_with_marine_returns_marine_pa
    pa = create(:protected_area, marine: true)
    _non_marine_pa = create(:protected_area, marine: false)

    result = ProtectedArea.search(marine: true)
    assert_equal [pa], result
  end
end
