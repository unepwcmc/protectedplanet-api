module GeometryConcern
  extend ActiveSupport::Concern

  included do
    scope :without_geometry, -> { select(column_names - self.geometry_columns) }
  end

  module ClassMethods
    def geometry_columns
      columns_hash.select { |_,v| v.type == :spatial }.keys
    end
  end

  def bounds
    rgeo_factory = RGeo::Geos.factory srid: 4326
    bounds = RGeo::Cartesian::BoundingBox.new rgeo_factory
    bounds.add bounding_box

    [
      [bounds.min_y, bounds.min_x],
      [bounds.max_y, bounds.max_x]
    ]
  end

  def geojson
    geom_size = ActiveRecord::Base.connection.select_value("""
      SELECT ST_MemSize(#{main_geom_column}) 
      FROM #{self.class.table_name} 
      WHERE id = #{id}
    """.squish)

    return nil if geom_size.nil?

    # This figure is based on testing SITE_ID 555592567 which already took 22 seconds to return 
    # https://unep-wcmc.codebasehq.com/projects/protected-planet-support-and-maintenance/tickets/353
    sql_query = if geom_size.to_i > 26_900_000
                  # If too large then don't use ST_MakeValid and capture errors (geom is not valid, nil etc...)
                  # ST_MakeValid is resource expensive method
                  <<~SQL.squish
                    SELECT ST_AsGeoJSON(ST_Simplify(#{main_geom_column}, 0.03), 3)
                    FROM #{self.class.table_name}
                    WHERE id = #{id}
                  SQL
                else
                  # use ST_MakeValid to fix any protential errors if geom_size is not ridiculous
                  <<~SQL.squish
                    SELECT ST_AsGeoJSON(ST_SimplifyPreserveTopology(ST_MakeValid(#{main_geom_column}), 0.003), 3)
                    FROM #{self.class.table_name}
                    WHERE id = #{id}
                  SQL
                end

    begin
      geojson = ActiveRecord::Base.connection.select_value(sql_query)
      return nil if geojson.nil?

      geometry = JSON.parse(geojson)
      return nil unless geometry.present?

      {
        "type" => "Feature",
        "properties" => geometry_properties,
        "geometry" => geometry
      }
    rescue
      nil
    end
  end

  private

  def geometry_properties
    if self.respond_to?(:marine) && marine
      {
        "fill-opacity" => 0.7,
        "stroke-width" => 0.05,
        "stroke" => "#2E5387",
        "fill" => "#3E7BB6",
        "marker-color" => "#2B3146"
      }
    else
      {
        "fill-opacity" => 0.7,
        "stroke-width" => 0.05,
        "stroke" => "#40541b",
        "fill" => "#83ad35",
        "marker-color" => "#2B3146"
      }
    end
  end

  def main_geom_column
    self.respond_to?(:the_geom) ? 'the_geom' : 'bounding_box'
  end
end
