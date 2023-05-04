class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true

  RATING_RANGE = 0..5

  validates :user_id, presence: true, uniqueness: { scope: %i[ratable_id ratable_type] }
  validates :rating, numericality: { in: RATING_RANGE }
end
