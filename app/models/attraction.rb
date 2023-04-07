class Attraction < ApplicationRecord
  include Attractionable

  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }

  validates :title, :description, presence: true
end
