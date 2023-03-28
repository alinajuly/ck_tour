class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :tour

  enum confirmation: { pending: 0, approved: 1, cancelled: 2 }

  validates :number_of_peoples, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
