require 'models/concerns/geometry_concern'

class ProtectedArea < ActiveRecord::Base
  include GeometryConcern

  belongs_to :iucn_category
  belongs_to :designation
  belongs_to :legal_status
  belongs_to :governance
  has_and_belongs_to_many :countries, -> { select(:id, :name, :iso_3) }
  has_and_belongs_to_many :sub_locations

  delegate :jurisdiction, to: :designation, allow_nil: true
end
