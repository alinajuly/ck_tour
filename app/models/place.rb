class Place < ApplicationRecord
  belongs_to :tour
  has_many :geolocations, as: :geolocationable
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  validates :name, presence: true
end
