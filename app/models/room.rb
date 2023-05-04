class Room < ApplicationRecord
  include ImageValidable

  belongs_to :accommodation
  has_many :amenities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  validates :places, :bed, :quantity, presence: true
  validates :name, :description, presence: true, length: { minimum: 5 }
  validates :price_per_night, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_image_format
end
