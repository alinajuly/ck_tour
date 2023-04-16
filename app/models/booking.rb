class Booking < ApplicationRecord
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

  def not_in_past
    # validate on upcoming of check_in and check_out dates
    errors.add(:check_in, "can't be in the past") if check_in.present? && check_in <= Date.today
    errors.add(:check_out, "can't be in the past") if check_out.present? && check_out < Date.today
  end

  def check_availability
    # array with date ranges when selected room is booked in future
    date_ranges = room.bookings.upcoming_booking.map { |b| b.check_in...b.check_out }
    # date range for new booking
    booking_range = (check_in...check_out)

    # check same rooms for booking on selected dates
    busy_rooms = 0
    date_ranges.each do |range|
      busy_rooms += 1 if range.overlaps? booking_range
    end

    # pass validation if no all same rooms are booked
    return if busy_rooms < room.quantity

    errors.add(:room, 'is not available on the selected dates')
  end

  def enough_places
    # pass validation if room places are enough for guests
    return if number_of_peoples <= room.places

    errors.add(:room, 'is not enough places in the selected room, please select less people and choose another room for the rest')
  end
end
