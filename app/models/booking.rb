class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  validates :check_in, :check_out, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
end
