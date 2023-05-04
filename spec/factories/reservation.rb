FactoryBot.define do
  factory :reservation do
    number_of_peoples { 2 }
    check_in { Time.now + 5.hours }
    check_out { Time.now + 8.hours }
    full_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    note { Faker::Movies::HarryPotter.quote }

    association :catering, factory: :catering
    association :user, factory: :user
  end
end
