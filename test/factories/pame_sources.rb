# frozen_string_literal: true

FactoryBot.define do
  factory :pame_source do
    skip_create

    initialize_with do
      src = ContractSamples::V4_PAME_SOURCE
      PameSource.find_or_initialize_by(id: src['eff_metaid']).tap do |ps|
        ps.assign_attributes(
          data_title: src['data_title'],
          resp_party: src['resp_party'],
          year: src['year'],
          language: src['language']
        )
        ps.save! if ps.new_record? || ps.changed?
      end
    end
  end
end
