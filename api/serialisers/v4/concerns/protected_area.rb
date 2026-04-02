module API
  module Serialisers
    module V4
      module Concerns
        module ProtectedArea
          module_function
    
          def add_field(payload, key, enabled)
            return unless enabled
    
            value = yield
            payload[key] = value unless value.nil?
          end
    
          def safe_value(record, method_name, fallback = nil)
            return record.public_send(method_name) if record.respond_to?(method_name)
            return fallback.call if fallback.respond_to?(:call)
    
            fallback
          end
    
          def countries_payload(countries)
            countries.map do |country|
              {
                "name" => country.name,
                "iso_3" => country.iso_3,
                "id" => country.iso_3
              }
            end
          end
    
          def iucn_category_payload(iucn_category)
            return nil unless iucn_category
    
            {
              "id" => iucn_category.id,
              "name" => iucn_category.name
            }
          end
    
          def designation_payload(designation)
            return nil unless designation
    
            {
              "id" => designation.id,
              "name" => designation.name,
              "jurisdiction" => jurisdiction_payload(designation.jurisdiction)
            }
          end
    
          def jurisdiction_payload(jurisdiction)
            return nil unless jurisdiction
    
            {
              "id" => jurisdiction.id,
              "name" => jurisdiction.name
            }
          end
    
          def no_take_status_payload(no_take_status)
            return nil unless no_take_status
    
            {
              "id" => no_take_status.id,
              "name" => no_take_status.name,
              "area" => no_take_status.area
            }
          end
    
          def legal_status_payload(legal_status)
            return nil unless legal_status
    
            {
              "id" => legal_status.id,
              "name" => legal_status.name
            }
          end
    
          def management_authority_payload(management_authority)
            return nil unless management_authority
    
            {
              "id" => management_authority.id,
              "name" => management_authority.name
            }
          end
    
          def governance_payload(governance)
            return nil unless governance
    
            {
              "id" => governance.id,
              "governance_type" => governance.governance_type
            }
          end
    
          def sources_payload(sources)
            sources.map do |source|
              {
                "id" => source.id,
                "title" => source.title,
                "responsible_party" => source.responsible_party,
                "year_updated" => source.year_updated
              }
            end
          end
    
          def realm_payload(realm)
            return nil unless realm
    
            {
              "id" => realm.id,
              "name" => realm.name
            }
          end
    
          def green_list_status_payload(green_list_status, legacy_aliases: false)
            return nil unless green_list_status
    
            payload = {
              "id" => green_list_status.id,
              "gl_status" => safe_value(green_list_status, :gl_status),
              "status" => safe_value(green_list_status, :gl_status), # Alias to gl_status. It will be removed in next version (v5), use gl_status.
              "gl_expiry" => safe_value(green_list_status, :gl_expiry),
              "expiry_date" => safe_value(green_list_status, :gl_expiry), # Alias to gl_expiry. It will be removed in next version (v5), use gl_expiry.
              "gl_link" => safe_value(green_list_status, :gl_link),
              "link" => safe_value(green_list_status, :gl_link) # Alias to gl_link. It will be removed in next version (v5), use gl_link.
            }
    
            return payload if legacy_aliases

            payload.slice("id", "gl_status", "gl_expiry", "gl_link")
          end
    
          def formatted_legal_status_updated_at(record)
            record.legal_status_updated_at&.strftime("%d/%m/%Y")
          end
        end
      end
    end
  end
end
