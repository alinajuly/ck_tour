class Tour < ApplicationRecord
  belongs_to :user
  has_many :places
  has_many :appointments
  has_many_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  enum status: { unpublished: 0, published: 1 }

  scope :geolocation_filter, ->(locality) { joins(places: :geolocations).where('locality ILIKE ?', "%#{locality}%") }

  validates :title, :description, :phone, :email, :seats, :time_start, :time_end, :reg_code, :address_owner, presence: true
  validates :price_per_one, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
