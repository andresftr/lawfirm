# frozen_string_literal: true

FactoryBot.define do
  factory :affair do
    file_number { Faker::Alphanumeric.unique.alphanumeric 6 }
    start_date { Faker::Date.between(3.years.ago, Date.today) }
    finish_date { Faker::Date.between(1.year.ago, 1.year.from_now) }
    status { 'unknown' }
    association :client_id, factory: :client

    trait :invalid do
      file_number { nil }
    end

    trait :without_finish_date do
      finish_date { nil }
    end
  end
end
