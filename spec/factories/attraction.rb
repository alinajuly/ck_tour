FactoryBot.define do
  factory :attraction do
    title { Faker::ProgrammingLanguage.name }
    description { Faker::ProgrammingLanguage.creator }
  end
end
