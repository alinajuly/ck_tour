FactoryBot.define do
  factory :attraction do
    title { Faker::ProgrammingLanguage.name }
    description { Faker::ProgrammingLanguage.creator }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/example_image.jpg", 'image/jpeg') }
  end
end
