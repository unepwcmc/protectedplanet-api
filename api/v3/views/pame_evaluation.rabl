# Renders a single PAME evaluation for v3 (v3 field names: metadata_id, method)
attributes :id, :url, :year
attribute :eff_metaid => :metadata_id
attribute :methodology => :method

child :pame_source => :source do
  attributes :data_title, :resp_party,
  :year, :language
end
