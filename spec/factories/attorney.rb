# frozen_string_literal: true

FactoryBot.define do
  factory :attorney do
    dni { Faker::Number.number(10) }
    full_name { Faker::Name.name }
    address { Faker::Address.street_address }
    nacionality { Faker::Address.country }

    trait :invalid do
      full_name { nil }
    end

    trait :without_address do
      address { nil }
    end
  end
end
