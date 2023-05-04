FactoryBot.define do
  factory :rate do
    rating { 5 }
    ratable_type { 'Attraction' }
  end
end
