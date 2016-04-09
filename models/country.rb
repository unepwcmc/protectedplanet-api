require 'models/concerns/geometry_concern'
require 'models/concerns/api_object'

class Country < ActiveRecord::Base
  include GeometryConcern
  include ApiObject

  self.api_attributes = [
    :name, :iso_3, :geometry,
    :country_statistic, :pame_statistic,
    :region, :designations,
    :iucn_categories, :governances
  ]

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

  def protected_areas_per_governance
    ActiveRecord::Base.connection.execute("""
      SELECT governances.id AS governance_id, governances.name AS governance_name, pas_per_governances.count, round((pas_per_governances.count::decimal/(SUM(pas_per_governances.count) OVER ())::decimal) * 100, 2) AS percentage
      FROM governances
      INNER JOIN (
        #{protected_areas_inner_join(:governance_id)}
      ) AS pas_per_governances
        ON pas_per_governances.governance_id = governances.id
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
