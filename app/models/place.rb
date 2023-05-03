class Place < ApplicationRecord
  include Imaginable

  belongs_to :tour
  has_many :geolocations, as: :geolocationable
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 255 }
  validate :validate_image_format
end
