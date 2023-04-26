class Reservation < ApplicationRecord
  include Reservationable

  belongs_to :user
  belongs_to :catering

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  scope :upcoming_reservation, -> { where('check_out >= ?', Time.now) }
  scope :archival_reservation, -> { where('check_out < ?', Time.now) }

  validates :check_in, :check_out, :number_of_peoples, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :not_in_past, on: :create
  validate :enough_places, on: :create
end
