# frozen_string_literal: true

FactoryGirl.define do
  factory :management_authority do
    sequence(:name) { |n| "Authority #{n}" }
  end
end
