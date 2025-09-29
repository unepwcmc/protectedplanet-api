require 'models/concerns/geometry_concern'
require 'models/concerns/api_object'

class ProtectedArea < ActiveRecord::Base
  include GeometryConcern
  include ApiObject

  self.api_attributes = [
    :site_id,
    :site_pid,
    :site_type,
    :international_criteria,
    :gis_marine_area,
    :gis_area,
    :verif,
    :parent_iso3,
    :marine, :realm,
    :name, :name_english, :original_name,
    :geometry, :is_green_list,
    :countries,
    :iucn_category, :designation,
    :link_to_pp, :no_take_status,
    :legal_status, :legal_status_updated_at,
    :management_plan, :management_authority,
    :governance, :governance_subtype, 
    :reported_area, :reported_marine_area,
    :owner_type, :ownership_subtype, 
    :pame_evaluations,
    :green_list_status, :green_list_url,
    :is_oecm, :supplementary_info,
    :conservation_objectives,
    :inland_waters,
    :oecm_assessment,
  
    # To be removed when we drop API v3
    :wdpa_id, :wdpa_pid, :marine_type, :sub_locations
  ]

  belongs_to :iucn_category
  belongs_to :designation
  belongs_to :legal_status
  belongs_to :governance
  belongs_to :no_take_status
  belongs_to :management_authority
  belongs_to :green_list_status
  has_and_belongs_to_many :countries, -> { select(:id, :name, :iso_3) }
  has_many :pame_evaluations
  has_and_belongs_to_many :sources

  delegate :jurisdiction, to: :designation, allow_nil: true

  scope :biopama, -> { joins(:countries).where("countries.is_biopama IS TRUE").distinct }
  scope :with_pame_evaluations, -> { joins(:pame_evaluations).where("pame_evaluations.id IS NOT NULL").distinct }

  SEARCHES = {
    country:       -> (scope, value) { scope.joins(:countries).where("countries.iso_3 = ?", value.upcase) },
    marine:        -> (scope, value) { scope.where(marine: value) },
    is_green_list: -> (scope, value) { scope.where(is_green_list: value) },
    designation:   -> (scope, value) { scope.where(designation_id: value) },
    jurisdiction:  -> (scope, value) { scope.joins(:designation).where("designations.jurisdiction_id = ?", value) },
    governance:    -> (scope, value) { scope.where(governance_id: value) },
    iucn_category: -> (scope, value) { scope.where(iucn_category_id: value) }
  }

  def self.search params
    collection = self.all
    params.each do |(key, value)|
      next if SEARCHES[key.to_sym].nil?
      collection = SEARCHES[key.to_sym][collection, value]
    end

    collection
  end

  def link_to_pp
    File.join($secrets[:host], self.wdpa_id.to_s)
  end

  def is_green_list
    green_list_status_id.present?
  end

  def name_english
    name
  end

  ###### 
  ###### Anything below this line is only used for API v3 and can be removed when we drop API v3
  ######

  # This is only used for API v3 and can be removed when we drop API v3
  def wdpa_id
    site_id
  end

  # This is only used for API v3 and can be removed when we drop API v3
  def wdpa_pid
    # In v3 wdpa_pid is basically wdpa_id (site_id) so keep it to return site_id
    site_id
  end

  # This is only used for API v3 and can be removed when we drop API v3
  def sub_locations
    []
  end

  ######
  ###### Only put anything below this line for API v3 and can be removed when we drop API v3
  ######
end
