class Source < ActiveRecord::Base
  has_and_belongs_to_many :protected_areas

  def year_updated
    update_year.to_date.year rescue nil
  end
end
