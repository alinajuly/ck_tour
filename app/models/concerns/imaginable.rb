module Imaginable
  extend ActiveSupport::Concern

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def validate_image_format
    return unless image.attached?

    errors.add(:image, 'must be a JPEG, PNG, or GIF') unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
  end
end
