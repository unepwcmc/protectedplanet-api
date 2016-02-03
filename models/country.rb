require 'models/concerns/geometry_concern'

class Country < ActiveRecord::Base
  include GeometryConcern

  belongs_to :region
  has_one :country_statistic
  has_one :pame_statistic
  has_many :sub_locations
  has_many :protected_areas
end
