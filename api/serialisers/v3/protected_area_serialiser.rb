require_relative 'concerns/protected_area'
require_relative 'pame_evaluation_serialiser'

module API
  module Serialisers
    module V3
      module ProtectedAreaSerialiser
        extend API::Serialisers::V3::Concerns::ProtectedArea

        module_function

        def collection(protected_areas, current_user:, with_geometry:)
          {
            'protected_areas' => protected_areas.map do |protected_area|
              payload(protected_area, current_user: current_user, with_geometry: with_geometry)
            end
          }
        end

        def single(protected_area, current_user:, with_geometry:)
          {
            'protected_area' => payload(
              protected_area,
              current_user: current_user,
              with_geometry: with_geometry
            )
          }
        end

        def payload(protected_area, current_user:, with_geometry:)
          payload = {
            'id' => protected_area.site_id,
            'wdpa_id' => protected_area.site_id,
            'wdpa_pid' => protected_area.site_id,
            'name' => protected_area.name,
            'original_name' => safe_value(protected_area, :original_name, -> { protected_area.name }),
            'international_criteria' => protected_area.international_criteria,
            'verif' => protected_area.verif,
            'parent_iso3' => protected_area.parent_iso3,
            'marine_type' => safe_value(protected_area, :marine_type),
            'gis_marine_area' => protected_area.gis_marine_area,
            'gis_area' => protected_area.gis_area
          }
          add_field(payload, 'geojson', current_user.access_to?(ProtectedArea, :geometry) && with_geometry) do
            protected_area.geojson
          end

          add_field(payload, 'marine', current_user.access_to?(ProtectedArea, :marine)) do
            protected_area.marine
          end

          add_field(payload, 'reported_marine_area', current_user.access_to?(ProtectedArea, :reported_marine_area)) do
            protected_area.reported_marine_area
          end

          add_field(payload, 'reported_area', current_user.access_to?(ProtectedArea, :reported_area)) do
            protected_area.reported_area
          end

          add_field(payload, 'management_plan', current_user.access_to?(ProtectedArea, :management_plan)) do
            protected_area.management_plan
          end

          add_field(payload, 'is_green_list', current_user.access_to?(ProtectedArea, :is_green_list)) do
            protected_area.is_green_list
          end

          add_field(payload, 'is_oecm', current_user.access_to?(ProtectedArea, :is_oecm)) do
            safe_value(protected_area, :is_oecm)
          end

          add_field(payload, 'supplementary_info', current_user.access_to?(ProtectedArea, :supplementary_info)) do
            safe_value(protected_area, :supplementary_info)
          end

          add_field(payload, 'conservation_objectives',
                    current_user.access_to?(ProtectedArea, :conservation_objectives)) do
            safe_value(protected_area, :conservation_objectives)
          end

          add_field(payload, 'owner_type', current_user.access_to?(ProtectedArea, :owner_type)) do
            protected_area.owner_type
          end

          add_field(payload, 'countries', current_user.access_to?(ProtectedArea, :countries)) do
            countries_payload(protected_area.countries)
          end

          add_field(payload, 'iucn_category', current_user.access_to?(ProtectedArea, :iucn_category)) do
            iucn_category_payload(protected_area.iucn_category)
          end

          add_field(payload, 'designation', current_user.access_to?(ProtectedArea, :designation)) do
            designation_payload(protected_area.designation)
          end

          add_field(payload, 'no_take_status', current_user.access_to?(ProtectedArea, :no_take_status)) do
            no_take_status_payload(protected_area.no_take_status)
          end

          add_field(payload, 'legal_status', current_user.access_to?(ProtectedArea, :legal_status)) do
            legal_status_payload(protected_area.legal_status)
          end

          add_field(payload, 'management_authority', current_user.access_to?(ProtectedArea, :management_authority)) do
            management_authority_payload(protected_area.management_authority)
          end

          add_field(payload, 'governance', current_user.access_to?(ProtectedArea, :governance)) do
            governance_payload(protected_area.governance)
          end

          if current_user.access_to?(ProtectedArea, :green_list_status)
            # Rabl emitted `green_list_status: null` when the association was nil.
            payload['green_list_status'] = green_list_status_payload(protected_area.green_list_status)
          end

          add_field(payload, 'sources', true) do
            sources_payload(protected_area.sources)
          end

          payload['sub_locations'] = []

          add_field(payload, 'links', current_user.access_to?(ProtectedArea, :link_to_pp)) do
            { 'protected_planet' => protected_area.link_to_pp }
          end

          add_field(payload, 'legal_status_updated_at',
                    current_user.access_to?(ProtectedArea, :legal_status_updated_at)) do
            formatted_legal_status_updated_at(protected_area)
          end

          add_field(payload, 'pame_evaluations', current_user.access_to?(ProtectedArea, :pame_evaluations)) do
            API::Serialisers::V3::PameEvaluationSerialiser.many(
              protected_area.all_pame_evaluations_from_current_pa_and_parcels
            )
          end

          payload
        end
      end
    end
  end
end
