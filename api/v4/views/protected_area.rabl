object @protected_area

# Basic that can be available for everyone no need to check permissions
# If they are here then they shouldn't be in the api_attributes array models/protected_area.rb
attribute   :name => :name_english
attribute   :original_name => :name
attributes  :site_id, :site_pid,
            :international_criteria,
            :verif, :parent_iso3,
            :gis_marine_area, :gis_area, 
            :site_type


# All fields below must be in api_attributes models/protected_area.rb and have a permission check

node :links do |pa|
  if @current_user.access_to?(ProtectedArea, :link_to_pp)
    {protected_planet: pa.link_to_pp}
  end
end

# Geometry
if @current_user.access_to?(ProtectedArea, :geometry)
  attribute :geojson, if: -> (_) { @with_geometry }
end

if @current_user.access_to?(ProtectedArea, :marine)
  attribute :marine
end

if @current_user.access_to?(ProtectedArea, :reported_marine_area)
  attribute :reported_marine_area
end

if @current_user.access_to?(ProtectedArea, :reported_area)
  attribute :reported_area
end

if @current_user.access_to?(ProtectedArea, :legal_status_updated_at)
  node :legal_status_updated_at do |pa|
    pa.legal_status_updated_at&.strftime("%d/%m/%Y")
  end
end

if @current_user.access_to?(ProtectedArea, :management_plan)
  attribute :management_plan
end

if @current_user.access_to?(ProtectedArea, :is_green_list)
  attribute :is_green_list
end

if @current_user.access_to?(ProtectedArea, :is_oecm)
  attribute :is_oecm
end

if @current_user.access_to?(ProtectedArea, :supplementary_info)
  attribute :supplementary_info
end

if @current_user.access_to?(ProtectedArea, :conservation_objectives)
  attribute :conservation_objectives
end

if @current_user.access_to?(ProtectedArea, :green_list_url)
  attribute :green_list_url
end

# Relations
if @current_user.access_to?(ProtectedArea, :countries)
  child :countries, object_root: false do
    attributes :name, :iso_3
    attribute :iso_3 => :id
  end
end

if @current_user.access_to?(ProtectedArea, :iucn_category)
  child :iucn_category, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedArea, :designation)
  child :designation, object_root: false do
    attributes :id, :name
    child :jurisdiction do
      attribute :id, :name
    end
  end
end

if @current_user.access_to?(ProtectedArea, :no_take_status)
  child :no_take_status, object_root: false do
    attributes :id, :name, :area
  end
end

if @current_user.access_to?(ProtectedArea, :legal_status)
  child :legal_status, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedArea, :management_authority)
  child :management_authority, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedArea, :governance)
  child :governance, object_root: false do
    attributes :id, :governance_type
  end
end

if @current_user.access_to?(ProtectedArea, :governance_subtype)
  attributes :governance_subtype
end

if @current_user.access_to?(ProtectedArea, :owner_type)
  attribute :owner_type
end

if @current_user.access_to?(ProtectedArea, :ownership_subtype)
  attribute :ownership_subtype
end

if @current_user.access_to?(ProtectedArea, :inland_waters)
  attribute :inland_waters
end

if @current_user.access_to?(ProtectedArea, :oecm_assessment)
  attribute :oecm_assessment
end

if @current_user.access_to?(ProtectedArea, :pame_evaluations)
  child :pame_evaluations do
    attributes :id, :metadata_id,
      :url, :year,
      :methodology
    child :pame_source => :source do
      attributes :data_title, :resp_party,
      :year, :language
    end
  end
end

if @current_user.access_to?(ProtectedArea, :green_list_status)
  child :green_list_status, object_root: false do
    attributes :id, :status, :expiry_date
  end
end

if @current_user.access_to?(ProtectedArea, :sources)
  child :sources, object_root: false do
    attributes :id, :title, :responsible_party, :year_updated
  end
end

if @current_user.access_to?(ProtectedArea, :realm)
  child :realm, object_root: false do
    attributes :id, :name
  end
end

if @current_user.access_to?(ProtectedArea, :protected_area_parcels)
  child :protected_area_parcels, object_root: false do
    extends "v4/views/protected_area_parcel"
  end
end

