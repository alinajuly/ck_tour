FactoryBot.define do
  factory :facility do
    data {
      {
        credit_card: Faker::Boolean.boolean,
        free_parking: Faker::Boolean.boolean,
        wi_fi: Faker::Boolean.boolean,
        breakfast: Faker::Boolean.boolean,
        pets: Faker::Boolean.boolean,
        hair_dryer: Faker::Boolean.boolean,
        nice_view: Faker::Boolean.boolean,
        inclusive: Faker::Boolean.boolean,
        checkin_start: "14:00",
        checkin_end: "00:00",
        checkout_start: "00:00",
        checkout_end: "12:00"
      }
    }

    association :accommodation, factory: :room
  end
end
