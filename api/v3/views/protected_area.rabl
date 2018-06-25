object @protected_area

# Basic
attribute :wdpa_id => :id
attributes :name, :original_name, :wdpa_id

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

# Relations
if @current_user.access_to?(ProtectedArea, :countries)
  child :countries, object_root: false do
    attributes :name, :iso_3
    attribute :iso_3 => :id
  end
end

if @current_user.access_to?(ProtectedArea, :sublocations)
  child :sublocations, object_root: false do
    attributes :id, :english_name
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

if @current_user.access_to?(ProtectedArea, :pame_evaluations)
  child :pame_evaluations, object_root: false do
    attributes :id, :methodology, :year
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

if @current_user.access_to?(ProtectedArea, :owner_type)
  attribute :owner_type
end
