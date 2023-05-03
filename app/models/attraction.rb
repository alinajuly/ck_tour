class Attraction < ApplicationRecord
  include Imaginable
  include ImageValidable

  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_many :rates, as: :ratable
  has_one_attached :image

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }
  scope :search_filter, ->(search) { joins(:geolocations).where('title||description||locality ILIKE ?', "%#{search}%") }

  validates :title, :description, presence: true
  validate :validate_image_format
end
