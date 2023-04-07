class Catering < ApplicationRecord
  belongs_to :user
  has_many :reservations
  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_many_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  enum status: { unpublished: 0, published: 1 }

  scope :geolocation_filter, ->(locality) { joins(places: :geolocations).where('locality ILIKE ?', "%#{locality}%") }

  validates :name, :description, :phone, :email, :places, :kind, :reg_code, :address_owner, presence: true
end
