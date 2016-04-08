module ApiObject
  extend ActiveSupport::Concern

  included do
    $api_objects ||= []
    $api_objects << self
  end

  module ClassMethods
    def api_attributes
      @api_attributes || []
    end

    def api_attributes=(attributes)
      @api_attributes = attributes
    end
  end
end
