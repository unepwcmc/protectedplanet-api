class LegalStatus < ActiveRecord::Base
  include ApiObject
  has_many :protected_areas
end
