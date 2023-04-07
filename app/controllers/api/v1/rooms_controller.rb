class Api::V1::RoomsController < ApplicationController
  before_action :set_accommodation
  before_action :set_room, only: %i[show update destroy]
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :authorize_policy

  # GET /api/v1/accommodations/1/rooms
  def index
    @check_in = params[:check_in]
    @check_out = params[:check_out]
    @number_of_peoples = params[:number_of_peoples]

    @rooms = if @check_in.present? && @check_out.present? && @number_of_peoples.present?
                available_rooms
             else
                @accommodation.rooms.all
             end

    authorize @rooms

    if @rooms
      # render json: { data: @rooms }, status: :ok
      render json: @rooms.as_json(include: :images).merge(
        images: @rooms.images.map do |image|
          url_for(image)
        end
      )
    else
      render json: @rooms.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1/rooms/1
  def show
    authorize @room

    render json: @room.as_json(include: :images).merge(
      images: @room.images.map do |image|
        url_for(image)
      end
    )
  end

  # POST /api/v1/rooms
  def create
    @room = @accommodation.rooms.create!(room_params)
    # @room = @accommodation.rooms.new(room_params.except(:images))
    @room.images.attach(params[:images])

    # images = params[:room][:images]
    #
    # if images
    #   images.each do |image|
    #     @room.images.attach(image)
    #   end
    # end

    authorize @room

    if @room.save
      render json: { data: @room }, status: :created
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/rooms/1
  def update
    @room.images.attach(params[:images]) if params[:images]

    authorize @room

    if @room.update(room_params)
      render json: { status: 'Update', data: @room }, status: :ok
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

  def booked_room_ids(check_in, check_out)
    Booking.joins(:room)
           .where(check_in: ..check_out, check_out: check_in..)
           .pluck(:room_id)
  end

  def available_rooms
    @free_places = @accommodation.rooms.where.not(id: booked_room_ids(@check_in, @check_out))
                                 .pluck(:places).sum
    return unless @free_places >= @number_of_peoples.to_i

    @available_rooms = @accommodation.rooms.where.not(id: booked_room_ids(@check_in, @check_out))
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.permit(:places, :bed, :name, :quantity, :description, :price_per_night, images: [])
  end

  def authorize_policy
    authorize Room
  end
end
