class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  validates :check_in, :check_out, :number_of_peoples, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :not_in_past
  validate :check_availability, on: :create
  validate :enough_places, on: :create

  def not_in_past
    errors.add(:check_in, "can't be in the past") if check_in.present? && check_in < Date.today

    return unless check_out.present? && check_out < Date.today

    errors.add(:check_out, "can't be in the past")
  end

  def check_availability
    return unless room.bookings.where.not(id:)
                      .where(check_in: ..check_out, check_out: check_in..)
                      .any? && busy_rooms >= room.quantity

    errors.add(:room, 'is not available on the selected dates')
  end

  def enough_places
    return unless number_of_peoples > room.places

    errors.add(:room, 'is not enough places in the selected room')
  end

  def busy_rooms
    room.bookings.where(check_in: ..check_out, check_out: check_in..).count
  end
end
