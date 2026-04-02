# frozen_string_literal: true

FactoryGirl.define do
  factory :realm do
    sequence(:name) { |n| "Realm #{n}" }
  end
end
