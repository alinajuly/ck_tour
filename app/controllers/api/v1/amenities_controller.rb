class Api::V1::AmenitiesController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index]
  before_action :authorize_policy
  before_action :set_accommodation
  before_action :set_room
  before_action :set_amenity, only: %i[update destroy]

  def index
    @amenities = @room.amenities.all
    authorize @amenities

    render json: @amenities, status: :ok
  end

  # POST /api/v1/amenities
  def create
    @amenity = @room.amenities.new(amenity_params)

    authorize @amenity

    if @amenity.save
      render json: { data: @amenity }, status: :created
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/amenities/1
  def update
    authorize @amenity

    if @amenity.update(amenity_params)
      render json: { status: 'Update', data: @amenity }, status: :ok
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/amenities/1
  def destroy
    authorize @amenity

    if @amenity.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @amenity.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find_by_id(params[:accommodation_id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_amenity
    @amenity = Amenity.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def amenity_params
    params.permit(:data)
  end

  def authorize_policy
    authorize Amenity
  end
end
