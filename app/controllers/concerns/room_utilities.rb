module RoomUtilities
  extend ActiveSupport::Concern
  
  def build_images
    params[:images].each do |img|
      @room.images.attach(io: img, filename: img.original_filename)
    end
  end

  def room_json
    render json: {
      data: {
        room: @room,
        image_urls: @room.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end
end
