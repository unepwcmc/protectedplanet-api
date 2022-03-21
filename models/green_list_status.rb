class GreenListStatus < ActiveRecord::Base
  has_one :protected_area
end
