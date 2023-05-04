FactoryBot.define do
  factory :booking do
    number_of_peoples { 1 }
    check_in { Date.today + 5.days }
    check_out { Date.today + 8.days }
    note { Faker::Movies::HarryPotter.quote }
    full_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    
    association :room, factory: :room
    association :user, factory: :user
  end
end
