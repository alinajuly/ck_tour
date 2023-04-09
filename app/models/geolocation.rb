class Geolocation < ApplicationRecord
  belongs_to :geolocationable, polymorphic: true

  LATT = { min_latt: -90, max_latt: 90 }
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: LATT[:min_latt], less_than_or_equal_to: LATT[:max_latt] }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :locality, presence: true
end
