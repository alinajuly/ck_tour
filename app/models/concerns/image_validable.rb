module ImageValidable
  extend ActiveSupport::Concern

  def validate_image_format
    return unless images.attached?

    images.each do |image|
      errors.add(:images, 'must be a JPEG, PNG, or GIF') unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
    end
  end
end
