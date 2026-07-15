# frozen_string_literal: true

FactoryBot.define do
  factory :realm do
    sequence(:name) { |n| "Realm #{n}" }
  end
end
