# frozen_string_literal: true

FactoryBot.define do
  factory :management_authority do
    sequence(:name) { |n| "Authority #{n}" }
  end
end
