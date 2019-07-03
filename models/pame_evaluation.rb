class PameEvaluation < ActiveRecord::Base
  belongs_to :protected_area
  belongs_to :pame_source
end
