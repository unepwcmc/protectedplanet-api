module API
  module Serialisers
    module V3
      module CountrySerialiser
        module_function

        GROUPED_GOVERNANCE_ORDER = [
          "Governance by Government",
          "Shared Governance",
          "Private Governance",
          "Governance by Indigenous Peoples and Local Communities",
          "Not Reported"
        ].freeze

        def collection(countries, current_user:, with_geometry:, iucn_category_long_names:, group_governances:)
          {
            "countries" => countries.map do |country|
              country_payload(
                country,
                current_user: current_user,
                with_geometry: with_geometry,
                iucn_category_long_names: iucn_category_long_names,
                group_governances: group_governances
              )
            end
          }
        end

        def single(country, current_user:, with_geometry:, iucn_category_long_names:, group_governances:)
          {
            "country" => country_payload(
              country,
              current_user: current_user,
              with_geometry: with_geometry,
              iucn_category_long_names: iucn_category_long_names,
              group_governances: group_governances
            )
          }
        end

        def country_payload(country, current_user:, with_geometry:, iucn_category_long_names:, group_governances:)
          # NOTE: Ruby hashes preserve insertion order; this serializer intentionally
          # inserts keys in the order expected by the legacy Rabl output.
          payload = {
            "name" => country.name,
            "iso_3" => country.iso_3,
            "id" => country.iso_3
          }

          add_field(payload, "statistics", current_user.access_to?(Country, :country_statistic)) do
            statistics_payload(country.country_statistic)
          end

          add_field(payload, "pame_statistics", current_user.access_to?(Country, :pame_statistic)) do
            pame_statistics_payload(country.pame_statistic)
          end

          add_field(payload, "region", current_user.access_to?(Country, :region)) do
            region_payload(country.region)
          end

          payload["pas_count"] = country.protected_areas.count
          payload["pas_national_count"] = protected_area_count(country, "National")
          payload["pas_regional_count"] = protected_area_count(country, "Regional")
          payload["pas_international_count"] = protected_area_count(country, "International")
          payload["pas_with_iucn_category_count"] = country.protected_areas.where("iucn_category_id IS NOT NULL").count
          payload["pas_with_iucn_category_percentage"] = protected_area_with_iucn_percentage(country)

          add_field(payload, "links", current_user.access_to?(Country, :link_to_pp)) do
            { "protected_planet" => country.link_to_pp }
          end

          add_field(payload, "geojson", current_user.access_to?(Country, :geometry) && with_geometry) do
            country.geojson
          end

          add_field(payload, "designations", current_user.access_to?(Country, :designations)) do
            designations_payload(country)
          end

          add_field(payload, "iucn_categories", current_user.access_to?(Country, :iucn_categories)) do
            iucn_categories_payload(country, iucn_category_long_names: iucn_category_long_names)
          end

          add_field(payload, "governances", current_user.access_to?(Country, :governances)) do
            governances_payload(country, grouped: group_governances)
          end

          payload
        end

        def add_field(payload, key, enabled)
          return unless enabled

          value = yield
          payload[key] = value unless value.nil?
        end

        def protected_area_count(country, jurisdiction_name)
          jurisdiction = Jurisdiction.find_by_name(jurisdiction_name)
          return 0 unless jurisdiction

          ProtectedArea.search(country: country.iso_3, jurisdiction: jurisdiction.id).count
        rescue StandardError
          0
        end

        def protected_area_with_iucn_percentage(country)
          with_category = country.protected_areas.where("iucn_category_id IS NOT NULL").count
          total = country.protected_areas.count

          total.positive? ? ((with_category.to_f / total) * 100).round(2) : 0.0
        end

        def statistics_payload(country_statistic)
          return nil unless country_statistic

          {
            "pa_land_area" => country_statistic.pa_land_area,
            "pa_marine_area" => country_statistic.pa_marine_area,
            "land_area" => country_statistic.land_area,
            "percentage_pa_land_cover" => country_statistic.percentage_pa_land_cover,
            "percentage_pa_marine_cover" => country_statistic.percentage_pa_marine_cover,
            "marine_area" => country_statistic.marine_area,
            "polygons_count" => country_statistic.polygons_count,
            "points_count" => country_statistic.points_count,
            "oecm_polygon_count" => country_statistic.oecm_polygon_count,
            "oecm_point_count" => country_statistic.oecm_point_count,
            "protected_area_polygon_count" => country_statistic.protected_area_polygon_count,
            "protected_area_point_count" => country_statistic.protected_area_point_count,
            "percentage_oecms_pa_marine_cover" => country_statistic.percentage_oecms_pa_marine_cover,
            "oecms_pa_land_area" => country_statistic.oecms_pa_land_area,
            "oecms_pa_marine_area" => country_statistic.oecms_pa_marine_area,
            "percentage_oecms_pa_land_cover" => country_statistic.percentage_oecms_pa_land_cover
          }
        end

        def pame_statistics_payload(pame_statistic)
          return nil unless pame_statistic

          {
            "assessments" => pame_statistic.assessments,
            "assessed_pas" => pame_statistic.assessed_pas,
            "pame_pa_land_area" => pame_statistic.pame_pa_land_area,
            "pame_percentage_pa_land_cover" => pame_statistic.pame_percentage_pa_land_cover,
            "pame_pa_marine_area" => pame_statistic.pame_pa_marine_area,
            "pame_percentage_pa_marine_cover" => pame_statistic.pame_percentage_pa_marine_cover
          }
        end

        def region_payload(region)
          return nil unless region

          {
            "name" => region.name,
            "iso" => region.iso
          }
        end

        def designations_payload(country)
          Jurisdiction.all.flat_map do |jurisdiction|
            country.protected_areas_per_designation(jurisdiction).map do |row|
              {
                "id" => row["designation_id"].to_i,
                "name" => row["designation_name"],
                "jurisdiction" => {
                  "id" => jurisdiction.id,
                  "name" => jurisdiction.name
                },
                "pas_count" => row["count"].to_i
              }
            end
          end
        end

        def iucn_categories_payload(country, iucn_category_long_names:)
          country.protected_areas_per_iucn_category.map do |row|
            name = row["iucn_category_name"]
            name = IucnCategory.new(name: name).long_name if iucn_category_long_names

            {
              "id" => row["iucn_category_id"].to_i,
              "name" => name,
              "pas_count" => row["count"].to_i,
              "pas_percentage" => row["percentage"].to_f.round(2)
            }
          end
        end

        def governances_payload(country, grouped:)
          rows = country.protected_areas_per_governance.map do |row|
            governance_name = row["governance_name"]

            {
              "id" => row["governance_id"].to_i,
              "name" => governance_name,
              "governance_type" => Governance.new(name: governance_name).governance_type,
              "pas_count" => row["count"].to_i,
              "pas_percentage" => row["percentage"].to_f.round(2)
            }
          end

          return rows unless grouped

          GROUPED_GOVERNANCE_ORDER.each_with_object({}) do |governance_type, hash|
            matching = rows.select { |row| row["governance_type"] == governance_type }
            next if matching.empty?

            hash[governance_type] = matching.sort_by { |row| row["name"] }
          end
        end
      end
    end
  end
end
