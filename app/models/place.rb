class Place < ApplicationRecord
  belongs_to :tour
  has_many :geolocations, as: :geolocationable
  has_one_attached :image

  validates :name, presence: true
end
