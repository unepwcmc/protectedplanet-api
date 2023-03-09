object @country

# Basic
attributes :name, :iso_3
attributes :iso_3 => :id

node(:pas_count) { |c|
  c.protected_areas.count
}
node(:pas_national_count) { |c|
  national = Jurisdiction.find_by_name("National")
  ProtectedArea.search(country: c.iso_3, jurisdiction: national.id).count rescue 0
}
node(:pas_regional_count) { |c|
  regional = Jurisdiction.find_by_name("Regional")
  ProtectedArea.search(country: c.iso_3, jurisdiction: regional.id).count rescue 0
}
node(:pas_international_count) { |c|
  international = Jurisdiction.find_by_name("International")
  ProtectedArea.search(country: c.iso_3, jurisdiction: international.id).count rescue 0
}
node(:pas_with_iucn_category_count) { |c|
  c.protected_areas.where("iucn_category_id IS NOT NULL").count
}
node(:pas_with_iucn_category_percentage) { |c|
  with_category = c.protected_areas.where("iucn_category_id IS NOT NULL").count
  all_pas = c.protected_areas.count
  all_pas > 0 ? ((with_category.to_f/all_pas)*100).round(2) : 0.0
}


node :links do |country|
  if @current_user.access_to?(Country, :link_to_pp)
    {protected_planet: country.link_to_pp}
  end
end

# Geometry
if @current_user.access_to?(Country, :geometry)
  attribute :geojson, if: -> (_) { @with_geometry }
end

# Relations
if @current_user.access_to?(Country, :country_statistic)
  child :country_statistic => :statistics do
    attributes :pa_land_area, :pa_marine_area,
      :land_area, :percentage_pa_land_cover,
      :percentage_pa_marine_cover, :marine_area,
      :polygons_count, :points_count,
      :oecm_polygon_count, :oecm_point_count,
      :protected_area_polygon_count, :protected_area_point_count,
      :percentage_oecms_pa_marine_cover, :oecms_pa_land_area,
      :oecms_pa_marine_area, :percentage_oecms_pa_land_cover
  end
end

if @current_user.access_to?(Country, :pame_statistic)
  child :pame_statistic => :pame_statistics do
    attributes :assessments, :assessed_pas,
      :pame_pa_land_area,
      :pame_percentage_pa_land_cover,
      :pame_pa_marine_area,
      :pame_percentage_pa_marine_cover
  end
end

if @current_user.access_to?(Country, :region)
  child :region do
    attributes :name, :iso
  end
end

if @current_user.access_to?(Country, :designations)
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
end

if @current_user.access_to?(Country, :iucn_categories)
  node :iucn_categories do |country|
    country.protected_areas_per_iucn_category.map do |row|
      if @iucn_category_long_names
        name = IucnCategory.new(name: row["iucn_category_name"]).long_name
      else
        name = row["iucn_category_name"]
      end

      {
        id:             row["iucn_category_id"].to_i,
        name:           name,
        pas_count:      row["count"].to_i,
        pas_percentage: row["percentage"].to_f.round(2)
      }
    end
  end
end

if @current_user.access_to?(Country, :governances)
  node :governances do |country|
    if @group_governances
      rows = country.protected_areas_per_governance
      grouped = rows.group_by { |row| Governance.new(name: row["governance_name"]).governance_type }


      [
        "Governance by Government",
        "Shared Governance",
        "Private Governance",
        "Governance by Indigenous Peoples and Local Communities",
        "Not Reported"
      ].each_with_object({}) do |type, hash|
        next unless grouped[type]
        hash[type] = grouped[type].sort_by { |row| row["governance_name"] }.map { |row|
          {
            id:              row["governance_id"].to_i,
            name:            row["governance_name"],
            governance_type: Governance.new(name: row["governance_name"]).governance_type,
            pas_count:       row["count"].to_i,
            pas_percentage:  row["percentage"].to_f.round(2)
          }
        }
      end
    else
      country.protected_areas_per_governance.map do |row|
        {
          id:              row["governance_id"].to_i,
          name:            row["governance_name"],
          governance_type: Governance.new(name: row["governance_name"]).governance_type,
          pas_count:       row["count"].to_i,
          pas_percentage:  row["percentage"].to_f.round(2)
        }
      end
    end
  end
end
