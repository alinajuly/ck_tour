class Tag < ApplicationRecord
  belongs_to :tagable, polymorphic: true

  validates :name, presence: true, uniqueness: { scope: %i[tagable_id tagable_type] }
end
