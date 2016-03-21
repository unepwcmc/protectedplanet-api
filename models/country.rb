require 'models/concerns/geometry_concern'

class Country < ActiveRecord::Base
  include GeometryConcern

  belongs_to :region
  has_one :country_statistic
  has_one :pame_statistic

  has_many :sub_locations
  has_many :protected_areas
  has_many :designations, -> { uniq }, through: :protected_areas

  def designations_per_jurisdiction
    designations.group_by { |designation|
      designation.jurisdiction.name rescue "Not Reported"
    }
  end

  def protected_areas_per_designation(jurisdiction=nil)
    ActiveRecord::Base.connection.execute("""
      SELECT designations.id AS designation_id, designations.name AS designation_name, pas_per_designations.count
      FROM designations
      INNER JOIN (
        #{protected_areas_inner_join(:designation_id)}
      ) AS pas_per_designations
        ON pas_per_designations.designation_id = designations.id
      #{"WHERE designations.jurisdiction_id = #{jurisdiction.id}" if jurisdiction}
    """)
  end

  def protected_areas_per_iucn_category
    ActiveRecord::Base.connection.execute("""
      SELECT iucn_categories.id AS iucn_category_id, iucn_categories.name AS iucn_category_name, pas_per_iucn_categories.count, round((pas_per_iucn_categories.count::decimal/(SUM(pas_per_iucn_categories.count) OVER ())::decimal) * 100, 2) AS percentage
      FROM iucn_categories
      INNER JOIN (
        #{protected_areas_inner_join(:iucn_category_id)}
      ) AS pas_per_iucn_categories
        ON pas_per_iucn_categories.iucn_category_id = iucn_categories.id
    """)
  end

  private

  def protected_areas_inner_join group_by
    """
      SELECT #{group_by}, COUNT(protected_areas.id) AS count
      FROM protected_areas
      INNER JOIN countries_protected_areas
        ON protected_areas.id = countries_protected_areas.protected_area_id
        AND countries_protected_areas.country_id = #{self.id}
      GROUP BY #{group_by}
    """
  end
end
