# Renders a single PAME evaluation (used from protected_area.rabl with object: evaluation)
attributes :eff_metaid, :asmt_year, :method, :asmt_url,
           :asmt_id, :submit_year,
           :verif_eff, :info_url, :gov_act, :gov_asmt,
           :dp_bio, :dp_other, :mgmt_obset, :mgmt_obman,
           :mgmt_adapt, :mgmt_staff, :mgmt_budgt, :mgmt_thrts,
           :mgmt_mon, :out_bio

# Alias, Remove it in next version (v5)
attributes :asmt_id => :id
# Alias, Remove it in next version (v5)
attribute :asmt_year => :year
# Alias, Remove it in next version (v5)
attribute :asmt_url => :url
# Alias, Remove it in next version (v5)
attribute :eff_metaid => :metadata_id
# Alias, remove it in next version (v5)
attribute :method => :methodology

child :pame_source => :source do
  attribute :id => :eff_metaid
  attributes :data_title, :resp_party,
  :year, :language
end

child :pame_method, object_root: false do
  attributes :id, :name
end
