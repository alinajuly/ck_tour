class Appointment < ApplicationRecord
  include Appointmentable

  belongs_to :user
  belongs_to :tour

  enum confirmation: %i[pending approved cancelled]

  scope :upcoming_appointment, -> { joins(:tour).where('time_end >= ?', Time.now) }
  scope :archival_appointment, -> { joins(:tour).where('time_end < ?', Time.now) }

  validates :number_of_peoples, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :enough_seats, on: :create
end
