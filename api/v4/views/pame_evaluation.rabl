# Renders a single PAME evaluation (used from protected_area.rabl with object: evaluation)
attributes :id, :eff_metaid,
  :url, :year,
  :method

child :pame_source => :source do
  attribute :id => :eff_metaid
  attributes :data_title, :resp_party,
  :year, :language
end

child :pame_method, object_root: false do
  attributes :id, :name
end
