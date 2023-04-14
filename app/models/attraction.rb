class Attraction < ApplicationRecord
  include Imaginable

  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_one_attached :image

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }

  validates :title, :description, presence: true
end
