class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  validates :check_in, :check_out, presence: true, availability: true
  validates :check_out, comparison: { greater_than: :check_in }
  validate :not_in_past

  def not_in_past
    if check_in.present? && check_in < Date.today
      errors.add(:check_in, 'can\'t be in the past')
    end

    if check_out.present? && check_out < Date.today
      errors.add(:check_out, 'can\'t be in the past')
    end
  end
end
