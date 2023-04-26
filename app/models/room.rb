class Room < ApplicationRecord
  belongs_to :accommodation
  has_many :amenities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  validates :name, :places, :bed, :description, :quantity, presence: true
  validates :price_per_night, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
