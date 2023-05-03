class Place < ApplicationRecord
  include Imaginable
  include ImageValidable

  belongs_to :tour
  has_many :geolocations, as: :geolocationable
  has_one_attached :image

  validates :name, presence: true
  validate :validate_image_format
end
