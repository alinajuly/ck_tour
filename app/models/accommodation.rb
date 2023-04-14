class Accommodation < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_many_attached :images

  enum status: { unpublished: 0, published: 1 }

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }

  validates :name, :description, :phone, :email, :kind, :reg_code, :address_owner, presence: true
end
