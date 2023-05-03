FactoryBot.define do
  factory :accommodation do
    name { Faker::Name.female_first_name }
    description { Faker::Quotes::Chiquito.expression }
    address_owner { Faker::Address.full_address }
    phone { '067-222-2222' }
    email { 'test@test.com' }
    reg_code { '11111111' }
    kind { Faker::House.room }
    person { Faker::Name.name_with_middle }

    association :user, factory: :user
  end
end
