FactoryBot.define do
  factory :amenity do
    data {
      {
        conditioner: Faker::Boolean.boolean,
        tv: Faker::Boolean.boolean,
        refrigerator: Faker::Boolean.boolean,
        kettle: Faker::Boolean.boolean,
        mv_owen: Faker::Boolean.boolean,
        hair_dryer: Faker::Boolean.boolean,
        nice_view: Faker::Boolean.boolean,
        inclusive: Faker::Boolean.boolean
      }
    }

    association :room, factory: :room
  end
end
