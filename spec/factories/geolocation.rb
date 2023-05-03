FactoryBot.define do
  factory :geolocation do
    locality { 'New York' }
    street { '5th Avenue' }
    suite { '25' }
    zip_code { '000000' }
    latitude { 49.445000 }
    longitude { 32.063333 }
    geolocationable_type { 'Attraction' }
  end
end
