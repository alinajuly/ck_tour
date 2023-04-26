class Booking < ApplicationRecord
  include Bookingable
  
  belongs_to :user
  belongs_to :room

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  scope :upcoming_booking, -> { where('check_out > ?', Date.today) }
  scope :archival_booking, -> { where('check_out =< ?', Date.today) }

  validates :check_in, :check_out, :number_of_peoples, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :not_in_past, on: :create
  validate :check_availability, on: :create
  validate :enough_places, on: :create
end
