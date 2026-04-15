# frozen_string_literal: true

require 'models/concerns/geometry_concern'
require 'models/concerns/api_object'

class ProtectedAreaParcel < ActiveRecord::Base
  include GeometryConcern
  include ApiObject

  # IMPORTANT: When adding/removing/modifying attributes in this array,
  # you MUST run `bundle exec rake api_users:reset_permissions` on all servers
  # to ensure existing API users have access to the new/changed fields.
  # 
  # NOTE: Basic attributes exposed in RABL views without permission checks
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
    :green_list_status, :green_list_url,
    :is_oecm, :supplementary_info,
    :conservation_objectives,
    :inland_waters, :oecm_assessment
  ]

  has_and_belongs_to_many :countries, -> { select(:id, :name, :iso_3) }
  has_and_belongs_to_many :sources
  has_many :pame_evaluations, -> { order(:id) }

  belongs_to :protected_area, foreign_key: 'site_id', primary_key: 'site_id'
  belongs_to :legal_status
  belongs_to :iucn_category
  belongs_to :governance
  belongs_to :management_authority
  belongs_to :realm
  belongs_to :no_take_status
  belongs_to :designation
  belongs_to :green_list_status
  delegate :jurisdiction, to: :designation, allow_nil: true

  # See ProtectedArea::API_JSON_INCLUDES — same idea: preload what API serialisers touch to avoid N+1 on index/search.
  API_JSON_INCLUDES = [
    :countries, :sources, :pame_evaluations, :protected_area,
    :iucn_category, :designation, :legal_status, :governance, :realm,
    :no_take_status, :management_authority, :green_list_status
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
    collection = with_api_json_includes # see API_JSON_INCLUDES
    params.each do |(key, value)|
      next if SEARCHES[key.to_sym].nil?
      collection = SEARCHES[key.to_sym][collection, value]
    end

    collection
  end

  def link_to_pp
    File.join(APP_SECRETS[:host], self.site_id.to_s)
  end

  def name_english
    name
  end

  def is_green_list
    green_list_status_id.present?
  end
end
