FactoryBot.define do
  factory :room do
    places { Faker::Number.between(from: 1, to: 5) }
    bed { Faker::Lorem.words(number: 2).join(" ") }
    price_per_night { Faker::Commerce.price(range: 50..500.0, as_string: true) }
    description { Faker::Lorem.paragraph }
    name { Faker::Lorem.sentence }
    quantity { Faker::Number.between(from: 1, to: 10) }

    association :accommodation, factory: :accommodation
  end
end
