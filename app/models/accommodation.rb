class Accommodation < ApplicationRecord
  has_many :rooms
  has_many :facilities
  has_many :coordinates, as: :coordinatable
  has_many :tags, as: :tagable
  has_many_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end
  enum status: { unpublished: 0, published: 1 }

  validates :name, :description, :address, :phone, :email, presence: true
  validates :kind, inclusion: { in: %w(hotel hostel apartment greenhouse), message: "%{value} is not a valid size" }
end
