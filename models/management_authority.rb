class ManagementAuthority < ActiveRecord::Base
  include ApiObject
  has_many :protected_areas
end
