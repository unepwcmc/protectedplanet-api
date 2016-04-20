require 'test_helper'
require 'models/concerns/api_object'
class ApiObjectTest < MiniTest::Test
  def test_including_api_object_adds_to_api_objects
    refute $api_objects.include?(TestClass)
    TestClass.send(:include, ApiObject)
    assert $api_objects.include?(TestClass)

    reset_api_objects(TestClass)
  end

  def test_including_api_object_let_set_api_attributes
    TestClass.send(:include, ApiObject)
    assert_equal [], TestClass.api_attributes

    TestClass.api_attributes = ["name", "iso_3"]
    assert_equal ["name", "iso_3"], TestClass.api_attributes

    reset_api_objects(TestClass)
  end

  private

  def reset_api_objects(klass)
    TestClass.remove_module(klass)
    $api_objects.reject!{ |o| o == klass }
  end
end
