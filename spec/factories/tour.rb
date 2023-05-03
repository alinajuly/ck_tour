FactoryBot.define do
  factory :tour do
    title { Faker::Space.galaxy }
    description { Faker::Quotes::Chiquito.expression }
    seats { 45 }
    price_per_one { 350 }
    time_start { Date.today + 7 }
    time_end { Date.today + 9 }
    address_owner { Faker::Address.full_address }
    phone { '067-222-2222' }
    email { 'test@test.com' }
    reg_code { '11111111' }
    person { Faker::Name.name_with_middle }
  end
end
