class ApiUser < ActiveRecord::Base
  before_create :set_permissions

  def activate!
    self.active = true
    save!

    refresh_token unless token
  end

  def deactivate!
    self.active = false
    save!
  end

  def refresh_token
    self.token = SecureRandom.hex
    save
  end

  def self.new_token
    SecureRandom.hex
  end

  def access_to?(api_object, attribute)
    return false if self.permissions.nil?

    object_name = if api_object.is_a?(Class)
      api_object.name
    else
      api_object.class.name
    end

    self.permissions[object_name]&.include?(attribute.to_s)
  end

  private

  def set_permissions
    self.permissions ||= {}

    $api_objects.each do |api_object|
      self.permissions[api_object] = api_object.api_attributes
    end
  end
end
