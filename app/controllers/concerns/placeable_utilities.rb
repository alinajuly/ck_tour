module PlaceableUtilities
  extend ActiveSupport::Concern

  def place_json
    render json: PlaceSerializer.new(@place).as_json(include: :geolocations, methods: [:image_url]), status: :ok
  end
end
