class Room < ApplicationRecord
  belongs_to :accommodation
  has_many :amenities, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  scope :busy_at, ->(check_in, check_out) { where(dob: start_date..end_date) }

  validates :name, :places, :bed, :description, :quantity, presence: true
  validates :price_per_night, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # def unavailable_dates
  #   bookings.pluck(:check_in, :check_out).map do |range|
  #     { from: range[0], to: range[1] }
  #   end
  # end
end
