require 'test_helper'
require 'models/api_user'

class ApiUserTest < MiniTest::Test
  def test_activate_sets_active_to_true
    api_user = create(:api_user, active: false)

    api_user.activate!
    assert api_user.active
  end

  def test_activate_sets_token_if_not_set
    api_user = create(:api_user, active: false, token: nil)

    api_user.activate!
    refute_nil api_user.token
  end

  def test_activate_doesnt_set_token_if_set
    api_user = create(:api_user, active: false, token: "123456")

    api_user.activate!
    assert_equal api_user.token, "123456"
  end

  def test_deactivate_sets_active_to_false
    api_user = create(:api_user, active: true)

    api_user.deactivate!
    refute api_user.active
  end

  def test_refresh_token_sets_a_new_token_for_the_api_user
    api_user = create(:api_user, token: "a token")

    api_user.refresh_token
    refute_equal api_user.token, "a token"
  end

  def test_access_to_returns_true_if_user_has_attribute_access
    api_user = create(:api_user, permissions: {"ProtectedArea" => ["name", "marine"]})
    assert api_user.access_to?(ProtectedArea, :marine)
  end

  def test_access_to_returns_false_if_user_has_no_attribute_access
    api_user = create(:api_user, permissions: {"ProtectedArea" => ["name", "marine"]})
    refute api_user.access_to?(ProtectedArea, :designation)
  end

  def test_access_to_returns_true_if_user_has_attribute_access
    api_user = create(:api_user, permissions: {"ProtectedArea" => ["name", "is_green_list"]})
    assert api_user.access_to?(ProtectedArea, :is_green_list)
  end

  def test_access_to_returns_false_if_user_has_no_attribute_access
    api_user = create(:api_user, permissions: {"ProtectedArea" => ["name", "is_green_list"]})
    refute api_user.access_to?(ProtectedArea, :designation)
  end

  def test_access_to_with_model_instance
    api_user = create(:api_user, permissions: {"ProtectedArea" => ["name", "marine"]})
    protected_area = create(:protected_area)

    assert api_user.access_to?(protected_area, :marine)
  end
end
