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
  node :marine do |pa|
    pa.marine == "t"
  end
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
