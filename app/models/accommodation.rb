class Accommodation < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_many :rates, as: :ratable
  has_many_attached :images

  enum status: [:unpublished, :published]

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }
  scope :filter_by_status, ->(status) { where(status: status) }
  scope :filter_by_partner, ->(user) { where(user_id: user) }

  validates :name, :description, :phone, :email, :kind, :reg_code, :address_owner, presence: true
end
