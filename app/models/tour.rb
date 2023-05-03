class Tour < ApplicationRecord
  include Imaginable
  include Tourable

  belongs_to :user
  has_many :places
  has_many :appointments
  has_many :comments, as: :commentable
  has_many :rates, as: :ratable

  enum status: %i[unpublished published]

  scope :geolocation_filter, ->(locality) { joins(places: :geolocations).where('locality ILIKE ?', "%#{locality}%") }
  scope :filter_by_partner, ->(user) { where(user_id: user) }
  scope :filter_by_status, ->(status) { where(status: status) }
  scope :upcoming_tours, -> { where('time_start >= ?', Time.now) }
  scope :archival_tours, -> { where('time_start < ?', Time.now) }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A\d{3}-\d{3}-\d{4}\z/
  VALID_REG_CODE_REGEX = /\A\d{8,10}\z/
  validates :title, :address_owner, :person, presence: true, length: { maximum: 255 }
  validates :description, :seats, :time_start, :time_end, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }
  validates :reg_code, presence: true, format: { with: VALID_REG_CODE_REGEX }
  validates :price_per_one, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :not_in_past, on: %i[create update]
end
