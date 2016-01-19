object @protected_area

# Basic
attribute :wdpa_id => :id
attributes :name, :original_name, :wdpa_id

node :marine do |pa|
  pa.marine == "t"
end

# Geometry
attribute :geojson, if: -> (_) { @with_geometry }

# Relations
child :countries, object_root: false do
  attributes :name, :iso_3
  attribute :iso_3 => :id
end
child :sublocations, object_root: false do
  attributes :id, :english_name
end
child :iucn_category, object_root: false do
  attributes :id, :name
end
child :designation, object_root: false do
  attributes :id, :name
end
