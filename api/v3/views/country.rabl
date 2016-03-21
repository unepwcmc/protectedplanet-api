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

child :pame_statistic => :pame_statistics do
  attributes :assessments, :assessed_pas,
    :average_score, :total_area_assessed,
    :percentage_area_assessed
end

child :region do
  attributes :name, :iso
end

node :designations do |country|
  Jurisdiction.all.flat_map do |jurisdiction|
    country.protected_areas_per_designation(jurisdiction).map do |row|
      {
        id:           row["designation_id"].to_i,
        name:         row["designation_name"],
        jurisdiction: {id: jurisdiction.id, name: jurisdiction.name},
        pas_count:    row["count"].to_i
      }
    end
  end
end

node :iucn_categories do |country|
  country.protected_areas_per_iucn_category.map do |row|
    {
      id:             row["iucn_category_id"].to_i,
      name:           row["iucn_category_name"],
      pas_count:      row["count"].to_i,
      pas_percentage: row["percentage"].to_f.round(2)
    }
  end
end
