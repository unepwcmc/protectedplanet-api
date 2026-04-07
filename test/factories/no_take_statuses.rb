# frozen_string_literal: true

FactoryBot.define do
  factory :no_take_status do
    sequence(:name) { |n| "No-take #{n}" }
    area { 0 }
  end
end
