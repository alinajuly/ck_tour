class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :catering

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  scope :upcoming_reservation, -> { where('check_out >= ?', Time.now) }
  scope :archival_reservation, -> { where('check_out < ?', Time.now) }

  validates :check_in, :check_out, :number_of_peoples, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :not_in_past, on: :create
  validate :enough_places, on: :create

  def not_in_past
    errors.add(:check_in, "can't be in the past") if check_in.present? && check_in < Date.today

    return unless check_out.present? && check_out < Date.today

    errors.add(:check_out, "can't be in the past")
  end

  def enough_places
    return unless catering.reservations.where(check_in: ..check_out, check_out: check_in..)
                          .pluck(:number_of_peoples).sum > catering.places

    errors.add(:catering, 'is not enough places in the selected restaurant on selected times')
  end
end
