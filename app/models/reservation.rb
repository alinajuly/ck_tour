class Reservation < ApplicationRecord
  include Reservationable

  belongs_to :user
  belongs_to :catering

  enum confirmation: %i[pending approved cancelled]

  scope :upcoming_reservation, -> { where('check_out >= ?', Time.current) }
  scope :archival_reservation, -> { where('check_out < ?', Time.current) }

  validates :check_in, :check_out, :number_of_peoples, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validates :number_of_peoples, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :not_in_past, on: :create
  validate :enough_places, on: :create
end
