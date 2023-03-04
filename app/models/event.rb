class Event < ApplicationRecord
  has_many :comments, as: :commentable
  has_many :tags, as: :tagable
  has_many :rates, as: :ratable
  has_many_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :main, resize_to_limit: [900, 900]
  end

  validates :title, :body, presence: true
  validates :date_start, :date_end, presence: true, availability: true
  validate :date_end_after_date_start
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  private

  def date_end_after_date_start
    return if date_end.blank? || date_start.blank?

    if date_end < date_start
      errors.add(:date_end, 'must be after the start date')
    end
  end
end
