class NoTakeStatus < ActiveRecord::Base
  include ApiObject
  has_one :protected_area
end
