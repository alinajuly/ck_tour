FactoryBot.define do
  factory :place do
    name { Faker::Movies::HarryPotter.location }
    body { Faker::Movies::HarryPotter.quote }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/example_image.jpg", 'image/jpeg') }

    association :tour, factory: :tour
  end
end
