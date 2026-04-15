# frozen_string_literal: true

FactoryGirl.define do
  factory :pame_method do
    skip_create

    initialize_with do
      PameMethod.find_or_create_by!(
        name: ContractSamples::V4_PAME_METHOD["name"]
      )
    end
  end
end
