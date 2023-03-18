class Api::V1::AmenitiesController < ApplicationController
  before_action :set_accommodation
  before_action :set_room
  before_action :set_amenity, only: %i[show destroy]

  def show
    render json: @amenity, status: :ok
  end

  # POST /api/v1/amenities
  def create
    @amenity = @room.amenities.new(amenity_params)
    if @amenity.save
      render json: { data: @amenity }, status: :created
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/amenities/1
  def update
    if @amenity.update(amenity_params)
      render json: { status: 'Update', data: @amenity }, status: :ok
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/amenities/1
  def destroy
    if @amenity.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find_by_id(params[:accommodation_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'accommodation id not found' }, status: :not_found
  end

  def set_room
    @room = Room.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'room id not found' }, status: :not_found
  end

  def set_amenity
    @amenity = Amenity.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'amenity id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def amenity_params
    params.permit(:conditioner, :tv, :refrigerator, :kettle, :mv_owen, :hair_dryer, :nice_view, :inclusive)
  end
end
