class PameEvaluation < ActiveRecord::Base
  belongs_to :protected_area
  belongs_to :protected_area_parcel
  belongs_to :pame_source
  belongs_to :pame_method
end
