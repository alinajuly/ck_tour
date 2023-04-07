module Attractionable
  extend ActiveSupport::Concern

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  # def image_url
  #   url_for(self.image) if image.attached?
  #   # rails_blob_url(image, only_path: true) if image.attached?
  # end
end
