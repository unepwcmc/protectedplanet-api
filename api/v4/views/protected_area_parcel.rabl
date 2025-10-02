# Protected Area Parcel view template
# Can be used standalone or as child template
# Always uses ProtectedAreaParcel permissions as defined in the model's api_attributes

object @protected_area_parcel

# Basic that can be available for everyone no need to check permissions
# If they are here then they shouldn't be in the api_attributes array models/protected_area_parcel.rb 
attribute   :name => :name_english
attribute   :original_name => :name
attributes  :site_id, :site_pid,
            :international_criteria,
            :verif, :parent_iso3,
            :gis_marine_area, :gis_area,
            :site_type

# All fields below must be in api_attributes and have a permission check

node :links do |pap|
  if @current_user.access_to?(ProtectedAreaParcel, :link_to_pp)
    {protected_planet: pap.link_to_pp}
  end
end

# Geometry
if @current_user.access_to?(ProtectedAreaParcel, :geometry)
  attribute :geojson, if: -> (_) { @with_geometry }
end

if @current_user.access_to?(ProtectedAreaParcel, :marine)
  attribute :marine
end

if @current_user.access_to?(ProtectedAreaParcel, :reported_marine_area)
  attribute :reported_marine_area
end

if @current_user.access_to?(ProtectedAreaParcel, :reported_area)
  attribute :reported_area
end

if @current_user.access_to?(ProtectedAreaParcel, :legal_status_updated_at)
  node :legal_status_updated_at do |pap|
    pap.legal_status_updated_at&.strftime("%d/%m/%Y")
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :management_plan)
  attribute :management_plan
end

if @current_user.access_to?(ProtectedAreaParcel, :is_green_list)
  attribute :is_green_list
end

if @current_user.access_to?(ProtectedAreaParcel, :is_oecm)
  attribute :is_oecm
end

if @current_user.access_to?(ProtectedAreaParcel, :supplementary_info)
  attribute :supplementary_info
end

if @current_user.access_to?(ProtectedAreaParcel, :conservation_objectives)
  attribute :conservation_objectives
end

if @current_user.access_to?(ProtectedAreaParcel, :green_list_url)
  attribute :green_list_url
end

if @current_user.access_to?(ProtectedAreaParcel, :inland_waters)
  attribute :inland_waters
end

if @current_user.access_to?(ProtectedAreaParcel, :oecm_assessment)
  attribute :oecm_assessment
end

# Relations
if @current_user.access_to?(ProtectedAreaParcel, :countries)
  child :countries, object_root: false do
    attributes :name, :iso_3
    attribute :iso_3 => :id
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :iucn_category)
  child :iucn_category, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :designation)
  child :designation, object_root: false do
    attributes :id, :name
    child :jurisdiction do
      attribute :id, :name
    end
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :no_take_status)
  child :no_take_status, object_root: false do
    attributes :id, :name, :area
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :legal_status)
  child :legal_status, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :management_authority)
  child :management_authority, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :governance)
  child :governance, object_root: false do
    attributes :id, :governance_type
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :governance_subtype)
  attribute :governance_subtype
end

if @current_user.access_to?(ProtectedAreaParcel, :owner_type)
  attribute :owner_type
end

if @current_user.access_to?(ProtectedAreaParcel, :ownership_subtype)
  attribute :ownership_subtype
end

if @current_user.access_to?(ProtectedAreaParcel, :sources)
  child :sources, object_root: false do
    attributes :id, :title, :responsible_party, :year_updated
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :realm)
  child :realm, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedAreaParcel, :green_list_status)
  child :green_list_status, object_root: false do
    attributes :id, :status, :expiry_date
  end
end


