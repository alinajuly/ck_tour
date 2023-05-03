FactoryBot.define do
  factory :appointment do
    number_of_peoples { 5 }
    full_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    note { Faker::Movies::HarryPotter.quote }

    association :tour, factory: :tour
    association :user, factory: :user
  end
end
