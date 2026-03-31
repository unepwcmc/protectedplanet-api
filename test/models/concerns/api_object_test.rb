require 'test_helper'
require 'models/concerns/api_object'
class ApiObjectTest < MiniTest::Test
  def test_including_api_object_adds_to_api_objects
    klass = build_test_class

    refute $api_objects.include?(klass)
    klass.send(:include, ApiObject)
    assert $api_objects.include?(klass)

    reset_api_objects(klass)
  end

  def test_including_api_object_let_set_api_attributes
    klass = build_test_class

    klass.send(:include, ApiObject)
    assert_equal [], klass.api_attributes

    klass.api_attributes = ["name", "iso_3"]
    assert_equal ["name", "iso_3"], klass.api_attributes

    reset_api_objects(klass)
  end

  private

  def build_test_class
    Class.new do
      def self.remove_module(mod)
        mod.instance_methods.each do |method_name|
          next if [:object_id, :__send__].include?(method_name)

          undef_method(method_name)
        end
      end
    end
  end

  def reset_api_objects(klass)
    klass.remove_module(klass)
    $api_objects.reject!{ |o| o == klass }
  end
end
