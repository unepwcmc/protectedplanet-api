class IucnCategory < ActiveRecord::Base
  has_many :protected_areas

  LONG_NAMES = {
    "Ia" => "Ia - Strict Nature Reserve",
    "Ib" => "Ib - Wilderness Area",
    "II" => "II - National Park",
    "III" => "III - Natural Monument or Feature",
    "IV" => "IV - Habitat/Species Management Area",
    "V" => "V - Protected Landscape/Seascape",
    "VI" => "VI - Protected Area with Sustainable Use of Natural Resources",
    "Not Applicable" => "Not Applicable",
    "Not Assigned" => "Not Assigned",
    "Not Reported" => "Not Reported"
  }
  def long_name
    LONG_NAMES[name]
  end
end
