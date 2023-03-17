class Room < ApplicationRecord
  belongs_to :accommodation
  has_many :amenities
  has_many :bookings
  has_many_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  validates :places, :bed, :description, presence: true
  validates :price_per_night, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # def unavailable_dates
  #   bookings.pluck(:check_in, :check_out).map do |range|
  #     { from: range[0], to: range[1] }
  #   end
  # end
end
