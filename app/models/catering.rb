class Catering < ApplicationRecord
  include ImageValidable

  belongs_to :user
  has_many :reservations
  has_many :geolocations, as: :geolocationable
  has_many :comments, as: :commentable
  has_many :rates, as: :ratable
  has_many_attached :images

  enum status: %i[unpublished published]

  scope :geolocation_filter, ->(locality) { joins(:geolocations).where('locality ILIKE ?', "%#{locality}%") }
  scope :filter_by_partner, ->(user) { where(user_id: user) }
  scope :filter_by_status, ->(status) { where(status: status) }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PHONE_REGEX = /\A\d{3}-\d{3}-\d{4}\z/
  VALID_REG_CODE_REGEX = /\A\d{8,10}\z/
  validates :name, :kind, :address_owner, :person, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :places, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }
  validates :reg_code, presence: true, format: { with: VALID_REG_CODE_REGEX }
  validate :validate_image_format
end
