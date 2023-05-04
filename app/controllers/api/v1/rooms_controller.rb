class Api::V1::RoomsController < ApplicationController
  include Rails.application.routes.url_helpers
  include Available
  include RoomableUtilities

  skip_before_action :authenticate_request, only: %i[index show]
  before_action :authorize_policy
  before_action :set_accommodation
  before_action :set_room, only: %i[show update destroy]

  # GET /api/v1/accommodations/1/rooms
  def index
    @rooms = if (params[:check_in] && params[:check_out] && params[:number_of_peoples]).present?
               available_rooms
             elsif @accommodation.rooms.present?
               @accommodation.rooms.all
end

    if @rooms.present?
      render json: { data: @rooms.map { |room| room.as_json.merge(images: room.images.map { |image| url_for(image) }) } }, status: :ok
    elsif @rooms.nil?
      render json: { data: 'Sorry, is not enough places in our accommodation' }
    else
      render json: @rooms.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1/rooms/1
  def show

    room_json
  end

  # POST /api/v1/rooms
  def create
    @room = @accommodation.rooms.new(room_params.except(:images))

    authorize @room

    build_images if params[:images].present?
    if @room.save
      room_json
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/rooms/1
  def update
    authorize @room

    if @room.update(room_params.except(:images))
      build_images if params[:images].present?
      room_json
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/rooms/1
  def destroy
    authorize @room

    if @room.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find_by_id(params[:accommodation_id])
  end

  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.permit(:places, :bed, :name, :quantity, :description, :price_per_night, images: [])
  end

  def authorize_policy
    authorize Room
  end
end
