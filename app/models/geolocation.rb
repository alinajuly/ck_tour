class Geolocation < ApplicationRecord
  belongs_to :geolocationable, polymorphic: true

  LATTITUDE = { min_lattitude: -90, max_lattitude: 90 }
  LONGITUDE = { min_longitude: -180, max_longitude: 180 }

  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: LATTITUDE[:min_lattitude], 
                                                       less_than_or_equal_to: LATTITUDE[:max_lattitude] }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: LONGITUDE[:min_longitude], 
                                                        less_than_or_equal_to: LONGITUDE[:max_longitude] }
  validates :locality, presence: true
end
