FactoryBot.define do
  factory :catering do
    name { Faker::Restaurant.name }
    description { Faker::Restaurant.description }
    address_owner { Faker::Address.full_address }
    phone { '067-222-2222' }
    email { 'test@test.com' }
    reg_code { '11111111' }
    kind { Faker::Restaurant.type }
    person { Faker::Name.name_with_middle }
    places { 85 }

    association :user, factory: :user
  end
end
