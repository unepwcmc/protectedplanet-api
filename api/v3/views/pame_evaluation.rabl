# Renders a single PAME evaluation for v3 (v3 field names: metadata_id, method)
attribute :asmt_id => :id
attribute :asmt_url => :url
attribute :asmt_year => :year
attribute :eff_metaid => :metadata_id
attribute :method => :methodology

child :pame_source => :source do
  attributes :data_title, :resp_party,
  :year, :language
end
