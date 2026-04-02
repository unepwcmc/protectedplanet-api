require_relative 'concerns/protected_area'
require_relative 'pame_evaluation_serialiser'

module API
  module Serialisers
    module V4
      module ProtectedAreaParcelSerializer
        extend API::Serialisers::V4::Concerns::ProtectedArea

        module_function

        def collection(protected_area_parcels, current_user:, with_geometry:)
          {
            'protected_area_parcels' => protected_area_parcels.map do |protected_area_parcel|
              payload(protected_area_parcel, current_user: current_user, with_geometry: with_geometry)
            end
          }
        end

        def single(protected_area_parcel, current_user:, with_geometry:)
          {
            'protected_area_parcel' => payload(
              protected_area_parcel,
              current_user: current_user,
              with_geometry: with_geometry
            )
          }
        end

        def payload(protected_area_parcel, current_user:, with_geometry:)
          payload = {
            'name_english' => protected_area_parcel.name_english,
            'name' => safe_value(protected_area_parcel, :original_name, -> { protected_area_parcel.name }),
            'site_id' => protected_area_parcel.site_id,
            'site_pid' => protected_area_parcel.site_pid,
            'international_criteria' => protected_area_parcel.international_criteria,
            'verif' => protected_area_parcel.verif,
            'parent_iso3' => protected_area_parcel.parent_iso3,
            'gis_marine_area' => protected_area_parcel.gis_marine_area,
            'gis_area' => protected_area_parcel.gis_area,
            'site_type' => protected_area_parcel.site_type
          }

          add_field(payload, 'geojson', current_user.access_to?(ProtectedAreaParcel, :geometry) && with_geometry) do
            protected_area_parcel.geojson
          end

          add_field(payload, 'marine', current_user.access_to?(ProtectedAreaParcel, :marine)) do
            protected_area_parcel.marine
          end

          add_field(payload, 'reported_marine_area',
                    current_user.access_to?(ProtectedAreaParcel, :reported_marine_area)) do
            protected_area_parcel.reported_marine_area
          end

          add_field(payload, 'reported_area', current_user.access_to?(ProtectedAreaParcel, :reported_area)) do
            protected_area_parcel.reported_area
          end

          add_field(payload, 'management_plan', current_user.access_to?(ProtectedAreaParcel, :management_plan)) do
            protected_area_parcel.management_plan
          end

          add_field(payload, 'is_green_list', current_user.access_to?(ProtectedAreaParcel, :is_green_list)) do
            protected_area_parcel.is_green_list
          end

          add_field(payload, 'is_oecm', current_user.access_to?(ProtectedAreaParcel, :is_oecm)) do
            safe_value(protected_area_parcel, :is_oecm)
          end

          add_field(payload, 'supplementary_info', current_user.access_to?(ProtectedAreaParcel, :supplementary_info)) do
            safe_value(protected_area_parcel, :supplementary_info)
          end

          add_field(payload, 'conservation_objectives',
                    current_user.access_to?(ProtectedAreaParcel, :conservation_objectives)) do
            safe_value(protected_area_parcel, :conservation_objectives)
          end

          add_field(payload, 'inland_waters', current_user.access_to?(ProtectedAreaParcel, :inland_waters)) do
            safe_value(protected_area_parcel, :inland_waters)
          end

          add_field(payload, 'oecm_assessment', current_user.access_to?(ProtectedAreaParcel, :oecm_assessment)) do
            safe_value(protected_area_parcel, :oecm_assessment)
          end

          add_field(payload, 'pame_evaluations', current_user.access_to?(ProtectedArea, :pame_evaluations)) do
            API::Serialisers::V4::PameEvaluationSerialiser.many(protected_area_parcel.pame_evaluations)
          end

          add_field(payload, 'countries', current_user.access_to?(ProtectedAreaParcel, :countries)) do
            countries_payload(protected_area_parcel.countries)
          end

          add_field(payload, 'iucn_category', current_user.access_to?(ProtectedAreaParcel, :iucn_category)) do
            iucn_category_payload(protected_area_parcel.iucn_category)
          end

          add_field(payload, 'designation', current_user.access_to?(ProtectedAreaParcel, :designation)) do
            designation_payload(protected_area_parcel.designation)
          end

          add_field(payload, 'no_take_status', current_user.access_to?(ProtectedAreaParcel, :no_take_status)) do
            no_take_status_payload(protected_area_parcel.no_take_status)
          end

          add_field(payload, 'legal_status', current_user.access_to?(ProtectedAreaParcel, :legal_status)) do
            legal_status_payload(protected_area_parcel.legal_status)
          end

          add_field(payload, 'management_authority',
                    current_user.access_to?(ProtectedAreaParcel, :management_authority)) do
            management_authority_payload(protected_area_parcel.management_authority)
          end

          add_field(payload, 'governance', current_user.access_to?(ProtectedAreaParcel, :governance)) do
            governance_payload(protected_area_parcel.governance)
          end

          add_field(payload, 'sources', current_user.access_to?(ProtectedAreaParcel, :sources)) do
            sources_payload(protected_area_parcel.sources)
          end

          add_field(payload, 'realm', current_user.access_to?(ProtectedAreaParcel, :realm)) do
            realm_payload(protected_area_parcel.realm)
          end

          if current_user.access_to?(ProtectedArea, :green_list_status)
            # Emit `green_list_status: null` when association is nil.
            payload['green_list_status'] = green_list_status_payload(protected_area_parcel.green_list_status)
          end

          add_field(payload, 'countries', current_user.access_to?(ProtectedAreaParcel, :countries)) do
            countries_payload(protected_area_parcel.countries)
          end

          add_field(payload, 'iucn_category', current_user.access_to?(ProtectedAreaParcel, :iucn_category)) do
            iucn_category_payload(protected_area_parcel.iucn_category)
          end

          add_field(payload, 'designation', current_user.access_to?(ProtectedAreaParcel, :designation)) do
            designation_payload(protected_area_parcel.designation)
          end

          add_field(payload, 'no_take_status', current_user.access_to?(ProtectedAreaParcel, :no_take_status)) do
            no_take_status_payload(protected_area_parcel.no_take_status)
          end

          add_field(payload, 'legal_status', current_user.access_to?(ProtectedAreaParcel, :legal_status)) do
            legal_status_payload(protected_area_parcel.legal_status)
          end

          add_field(payload, 'management_authority',
                    current_user.access_to?(ProtectedAreaParcel, :management_authority)) do
            management_authority_payload(protected_area_parcel.management_authority)
          end

          add_field(payload, 'governance', current_user.access_to?(ProtectedAreaParcel, :governance)) do
            governance_payload(protected_area_parcel.governance)
          end

          add_field(payload, 'governance_subtype', current_user.access_to?(ProtectedAreaParcel, :governance_subtype)) do
            safe_value(protected_area_parcel, :governance_subtype)
          end

          add_field(payload, 'owner_type', current_user.access_to?(ProtectedAreaParcel, :owner_type)) do
            protected_area_parcel.owner_type
          end

          add_field(payload, 'ownership_subtype', current_user.access_to?(ProtectedAreaParcel, :ownership_subtype)) do
            safe_value(protected_area_parcel, :ownership_subtype)
          end

          add_field(payload, 'sources', current_user.access_to?(ProtectedAreaParcel, :sources)) do
            sources_payload(protected_area_parcel.sources)
          end

          add_field(payload, 'realm', current_user.access_to?(ProtectedAreaParcel, :realm)) do
            realm_payload(protected_area_parcel.realm)
          end

          add_field(payload, 'links', current_user.access_to?(ProtectedAreaParcel, :link_to_pp)) do
            { 'protected_planet' => protected_area_parcel.link_to_pp }
          end

          add_field(payload, 'legal_status_updated_at',
                    current_user.access_to?(ProtectedAreaParcel, :legal_status_updated_at)) do
            formatted_legal_status_updated_at(protected_area_parcel)
          end

          payload
        end
      end
    end
  end
end
