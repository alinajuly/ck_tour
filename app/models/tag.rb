class Tag < ApplicationRecord
  belongs_to :tagable, polymorphic: true

  validates :locality, presence: true, uniqueness: { scope: %i[tagable_id tagable_type] }
end
