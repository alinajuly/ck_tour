class Attraction < ApplicationRecord
  has_many :coordinates, as: :coordinatable
  has_many :toponyms, as: :toponymable
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  scope :toponym_filter, ->(locality) { joins(:toponyms).where('locality ILIKE ?', "%#{locality}%") }

  validates :title, :description, presence: true
end
