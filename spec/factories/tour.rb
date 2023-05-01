FactoryBot.define do
  factory :tour do
    title { Faker::Space.galaxy }
    description { Faker::Quotes::Chiquito.expression }
    seats { 45 }
    price_per_one { 350 }
    time_start { Date.today + 7 }
    time_end { Date.today + 9 }
    address_owner { Faker::Address.full_address }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    email { 'test@test.com' }
    reg_code { Faker::IDNumber.spanish_citizen_number }
    person { Faker::Name.last_name }
  end
end
