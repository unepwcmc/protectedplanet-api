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

  SEARCHES = {
    country: -> (scope, value) { scope.joins(:countries).where("countries.iso_3 = ?", value) },
    marine:  -> (scope, value) { scope.where(marine: value) }
  }

  def self.search params
    collection = self.all
    params.each do |(key, value)|
      next if SEARCHES[key.to_sym].nil?
      collection = SEARCHES[key.to_sym][collection, value]
    end

    collection
  end
end
