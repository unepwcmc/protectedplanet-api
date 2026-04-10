require 'test_helper'
require 'models/concerns/api_object'

class ApiObjectTest < MiniTest::Test
  def test_including_api_object_adds_to_api_objects
    klass = Class.new
    refute $api_objects.include?(klass)
    klass.send(:include, ApiObject)
    assert $api_objects.include?(klass)
  ensure
    $api_objects.reject! { |o| o == klass } if klass
  end

  def test_including_api_object_let_set_api_attributes
    klass = Class.new
    klass.send(:include, ApiObject)
    assert_equal [], klass.api_attributes

    klass.api_attributes = %w[name iso_3]
    assert_equal %w[name iso_3], klass.api_attributes
  ensure
    $api_objects.reject! { |o| o == klass } if klass
  end
end
