object @country

# Basic
attributes :name, :iso_3
attributes :iso_3 => :id

# Geometry
attribute :geojson, if: -> (_) { @with_geometry }

# Relations
child :country_statistic => :statistics do
  attributes :pa_area, :percentage_cover_pas, :eez_area,
    :ts_area, :pa_land_area, :pa_marine_area, :percentage_pa_land_cover,
    :percentage_pa_eez_cover, :percentage_pa_ts_cover, :land_area, :percentage_pa_cover,
    :pa_eez_area, :pa_ts_area, :percentage_pa_marine_cover, :marine_area,
    :polygons_count, :points_count
end

child :region do
  attributes :name, :iso
end
