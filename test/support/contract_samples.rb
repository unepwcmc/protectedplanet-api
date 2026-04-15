# frozen_string_literal: true

# Single source of truth for staging-shaped literals used in contract tests and factories
# (`test/api/v3/contract_helpers.rb`, `test/api/v4/contract_helpers.rb`).
# v3 PAME JSON expectations are derived from the v4 hashes where v3 RABL aliases the same columns.
module ContractSamples
  V4_PAME_EVALUATION = {
    "eff_metaid" => 28,
    "asmt_year" => 2009,
    "method" => "Management Effectiveness Tracking Tool (METT)",
    "asmt_url" => "Not reported",
    "submit_year" => 2009,
    "verif_eff" => "Not Reported",
    "info_url" => "Not reported",
    "gov_act" => "Not reported",
    "gov_asmt" => "Not reported",
    "dp_bio" => "Not reported",
    "dp_other" => "Not reported",
    "mgmt_obset" => "Not reported",
    "mgmt_obman" => "Not reported",
    "mgmt_adapt" => "Not reported",
    "mgmt_staff" => "Not reported",
    "mgmt_budgt" => "Not reported",
    "mgmt_thrts" => "Not reported",
    "mgmt_mon" => "Not reported",
    "out_bio" => "Not reported"
  }.freeze

  V4_PAME_SOURCE = {
    "eff_metaid" => 28,
    "data_title" => "GD-PAME, version pre-2017",
    "resp_party" => "Not Reported",
    "year" => 2018,
    "language" => "English"
  }.freeze

  V4_PAME_METHOD = {
    "name" => "Management Effectiveness Tracking Tool (METT)"
  }.freeze

  GREEN_LIST_EXPIRY = Date.new(2029, 9, 29)
  GREEN_LIST_LINK = "https://iucngreenlist.org/sites/shandong-kunyushan-national-nature-reserve/".freeze
  GREEN_LIST_STATUS_LABEL = "Re-Listed"

  GREEN_LIST_STATUS_ATTRIBUTES = {
    gl_status: GREEN_LIST_STATUS_LABEL,
    gl_expiry: GREEN_LIST_EXPIRY,
    gl_link: GREEN_LIST_LINK
  }.freeze

  V4_GREEN_LIST = {
    "gl_status" => GREEN_LIST_STATUS_LABEL,
    "gl_expiry" => GREEN_LIST_EXPIRY.strftime("%Y-%m-%d"),
    "gl_link" => GREEN_LIST_LINK
  }.freeze

  V3_GREEN_LIST = {
    "status" => GREEN_LIST_STATUS_LABEL,
    "expiry_date" => GREEN_LIST_EXPIRY.strftime("%Y-%m-%d"),
    "link" => GREEN_LIST_LINK
  }.freeze

  SAMPLE_COUNTRY = {
    "id" => "ATG",
    "name" => "Antigua and Barbuda",
    "iso_3" => "ATG"
  }.freeze

  V3_PAME_EVALUATION = {
    "url" => V4_PAME_EVALUATION["asmt_url"],
    "metadata_id" => V4_PAME_EVALUATION["eff_metaid"],
    "methodology" => V4_PAME_EVALUATION["method"]
  }.freeze

  V3_PAME_SOURCE = {
    "data_title" => V4_PAME_SOURCE["data_title"],
    "resp_party" => V4_PAME_SOURCE["resp_party"],
    "year" => V4_PAME_SOURCE["year"],
    "language" => V4_PAME_SOURCE["language"]
  }.freeze
end
