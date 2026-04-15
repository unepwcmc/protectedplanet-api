# frozen_string_literal: true

FactoryBot.define do
  factory :pame_evaluation do
    association :protected_area
    association :pame_source
    association :pame_method

    eff_metaid { ContractSamples::V4_PAME_EVALUATION['eff_metaid'] }
    asmt_year { ContractSamples::V4_PAME_EVALUATION['asmt_year'] }
    asmt_url { ContractSamples::V4_PAME_EVALUATION['asmt_url'] }
    sequence(:asmt_id) { |n| 11_516 + n }
    submit_year { ContractSamples::V4_PAME_EVALUATION['submit_year'] }
    verif_eff { ContractSamples::V4_PAME_EVALUATION['verif_eff'] }
    info_url { ContractSamples::V4_PAME_EVALUATION['info_url'] }
    gov_act { ContractSamples::V4_PAME_EVALUATION['gov_act'] }
    gov_asmt { ContractSamples::V4_PAME_EVALUATION['gov_asmt'] }
    dp_bio { ContractSamples::V4_PAME_EVALUATION['dp_bio'] }
    dp_other { ContractSamples::V4_PAME_EVALUATION['dp_other'] }
    mgmt_obset { ContractSamples::V4_PAME_EVALUATION['mgmt_obset'] }
    mgmt_obman { ContractSamples::V4_PAME_EVALUATION['mgmt_obman'] }
    mgmt_adapt { ContractSamples::V4_PAME_EVALUATION['mgmt_adapt'] }
    mgmt_staff { ContractSamples::V4_PAME_EVALUATION['mgmt_staff'] }
    mgmt_budgt { ContractSamples::V4_PAME_EVALUATION['mgmt_budgt'] }
    mgmt_thrts { ContractSamples::V4_PAME_EVALUATION['mgmt_thrts'] }
    mgmt_mon { ContractSamples::V4_PAME_EVALUATION['mgmt_mon'] }
    out_bio { ContractSamples::V4_PAME_EVALUATION['out_bio'] }

    # Column is `method` (reserved in Ruby); use [] assignment — write_attribute is private on AR 4.2.
    after(:build) do |pe|
      pe['method'] = ContractSamples::V4_PAME_EVALUATION['method']
    end
  end
end
