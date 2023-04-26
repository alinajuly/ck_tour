module AccommodationableUtilities
  extend ActiveSupport::Concern
  
  def accommodation_json
    render json: {
      data: {
        accommodation: @accommodation,
        image_urls: @accommodation.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end

  def build_images
    params[:images].each do |img|
      @accommodation.images.attach(io: img, filename: img.original_filename)
    end
  end

  def available_accommodations
    available_accommodations = []
    # select published accommodations in definite location
    Accommodation.where(status: 1).geolocation_filter(params[:geolocations]).each do |accommodation|
      # instance variable for Available concern
      @accommodation = accommodation
      # check for selected accommodations with free rooms
      available_accommodations << accommodation if available_rooms.present?
    end
    available_accommodations
  end

  # Only allow a list of trusted parameters through.
  def edit_accommodation_params
    params.permit(policy(@accommodation).permitted_attributes)
  end
end
