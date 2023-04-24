FactoryBot.define do
  factory :user do
    name { Faker::Name.last_name }
    email { 'user@test.com' }
    password { 'User123!' }
  end
end
