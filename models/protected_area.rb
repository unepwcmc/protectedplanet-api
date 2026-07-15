require 'models/concerns/geometry_concern'
require 'models/concerns/api_object'

class ProtectedArea < ActiveRecord::Base
  include GeometryConcern
  include ApiObject

  # IMPORTANT: When adding/removing/modifying attributes in this array,
  # you MUST run `bundle exec rake api_users:reset_permissions` on all servers
  # to ensure existing API users have access to the new/changed fields.
  # 
  # NOTE: Basic attributes exposed in RABL views (api/vx/views/protected_area.rabl) without permission checks
  # (like site_id, site_pid, name, etc.) should NOT be included here.
  self.api_attributes = [
    :marine, :realm,
    :geometry, :is_green_list,
    :countries, :sources,
    :iucn_category, :designation,
    :link_to_pp, :no_take_status,
    :legal_status, :legal_status_updated_at,
    :management_plan, :management_authority,
    :governance, :governance_subtype, 
    :reported_area, :reported_marine_area,
    :owner_type, :ownership_subtype, 
    :pame_evaluations, :protected_area_parcels,
    :green_list_status, :green_list_url,
    :is_oecm, :supplementary_info,
    :conservation_objectives,
    :inland_waters,
    :oecm_assessment
  ]

  belongs_to :iucn_category
  belongs_to :designation
  belongs_to :legal_status
  belongs_to :governance
  belongs_to :realm
  belongs_to :no_take_status
  belongs_to :management_authority
  belongs_to :green_list_status
  has_and_belongs_to_many :countries, -> { select(:id, :name, :iso_3) }
  has_many :pame_evaluations, -> { order(:id) }
  has_and_belongs_to_many :sources
  has_many :protected_area_parcels, -> { order(:site_pid) }, foreign_key: 'site_id', primary_key: 'site_id'

  delegate :jurisdiction, to: :designation, allow_nil: true

  scope :biopama, -> { joins(:countries).where("countries.is_biopama IS TRUE").distinct }
  scope :with_pame_evaluations, -> { joins(:pame_evaluations).where("pame_evaluations.id IS NOT NULL").distinct }

  # Associations the JSON serialisers read for API responses. Eager-loaded via +with_api_json_includes+ to avoid
  # N+1 queries when rendering collections (list/search/biopama). If serializers gain new associations, add them here.
  API_JSON_INCLUDES = [
    :iucn_category, :designation, :legal_status, :governance, :realm,
    :no_take_status, :management_authority, :green_list_status,
    :countries, :sources, :pame_evaluations, :protected_area_parcels
  ].freeze

  scope :with_api_json_includes, -> { includes(API_JSON_INCLUDES) }

  SEARCHES = {
    country:       -> (scope, value) { scope.joins(:countries).where("countries.iso_3 = ?", value.upcase) },
    marine:        -> (scope, value) { scope.where(marine: value) },
    is_green_list: -> (scope, _value) { scope.where.not(green_list_status_id: nil) },
    designation:   -> (scope, value) { scope.where(designation_id: value) },
    jurisdiction:  -> (scope, value) { scope.joins(:designation).where("designations.jurisdiction_id = ?", value) },
    governance:    -> (scope, value) { scope.where(governance_id: value) },
    iucn_category: -> (scope, value) { scope.where(iucn_category_id: value) }
  }

  def self.search params
    # Start from eager-loaded scope so filtered search results still preload associations for serialisation.
    collection = with_api_json_includes
    params.each do |(key, value)|
      next if SEARCHES[key.to_sym].nil?
      collection = SEARCHES[key.to_sym][collection, value]
    end

    collection
  end

  def link_to_pp
    File.join(APP_SECRETS[:host], self.site_id.to_s)
  end

  def is_green_list
    green_list_status_id.present?
  end

  # In v4 we expose all PAME evaluations for this protected area and its parcels.
  def all_pame_evaluations_from_current_pa_and_parcels
    pa_parcel_internal_ids = protected_area_parcels.pluck(:id)
    if pa_parcel_internal_ids.any?
      PameEvaluation.where(
        "protected_area_id = ? OR protected_area_parcel_id IN (?)",
        id, pa_parcel_internal_ids
      ).distinct.order(:id)
    else
      PameEvaluation.where(protected_area_id: id).order(:id)
    end
  end
end
