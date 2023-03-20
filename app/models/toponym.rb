class Toponym < ApplicationRecord
  belongs_to :toponymable, polymorphic: true

  validates :locality, presence: true, uniqueness: { scope: %i[toponymable_id toponymable_type] }
end
