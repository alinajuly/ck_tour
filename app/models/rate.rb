class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true

  validates :user_id, presence: true, uniqueness: { scope: %i[ratable_id ratable_type] }
  validates :rating, numericality: { in: 0..5 }
end
