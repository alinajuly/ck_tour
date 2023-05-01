FactoryBot.define do
  factory :comment do
    body { 'Nice view' }
    commentable_type { 'Attraction' }
  end
end
