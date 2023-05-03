FactoryBot.define do
  factory :user do
    name { Faker::Name.name_with_middle }
    email { 'user@test.com' }
    password { 'User123!' }
  end
end
