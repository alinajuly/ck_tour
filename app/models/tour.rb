class Tour < ApplicationRecord
  include Imaginable

  belongs_to :user
  has_many :places
  has_many :appointments
  has_many :comments, as: :commentable

  enum status: { unpublished: 0, published: 1 }

  scope :geolocation_filter, ->(locality) { joins(places: :geolocations).where('locality ILIKE ?', "%#{locality}%") }
  scope :filter_by_partner, ->(user) { where(user_id: user) }
  scope :filter_by_status, ->(status) { where(status: status) }
  scope :upcoming_tours, -> { where('time_start >= ?', Time.now) }
  scope :archival_tours, -> { where('time_start < ?', Time.now) }

  validates :title, :description, :phone, :email, :seats, :time_start, :time_end, :reg_code, :address_owner, presence: true
  validates :price_per_one, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :not_in_past, on: :create

  def not_in_past
    errors.add(:time_start, "can't be in the past") if time_start < Time.now
  end
end
