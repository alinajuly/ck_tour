class Api::V1::AccommodationsController < ApplicationController
  before_action :set_accommodation, only: %i[show update destroy]

  # GET /api/v1/accommodations
  def index
    # @available_rooms = Room.available_rooms(params[:check_in], params[:check_out], params[:number_of_people])
    # debugger
    @accommodations = if params[:tags].present? && @available_rooms.present?
                        Accommodation.where(rooms: { id: @available_rooms.pluck(:id) })
                                     .tag_filter(params[:tags])
                                     .distinct
                      elsif params[:tags].present?
                        Accommodation.tag_filter(params[:tags])
                      else
                        Accommodation.all
                      end

    if @accommodations
      render json: { data: @accommodations }, status: :ok
    else
      render json: @accommodations.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1
  def show
    @rooms = @accommodation.rooms
    render json: { data: @accommodation, rooms: @rooms }, status: :ok
  end

  # POST /api/v1/accommodations
  def create
    @accommodation = Accommodation.new(accommodation_params)
    if @accommodation.save
      render json: { data: @accommodation }, status: :created
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/accommodations/1
  def update
    if @accommodation.update(accommodation_params)
      render json: { status: 'Update', data: @accommodation }, status: :ok
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/accommodations/1
  def destroy
    if @accommodation.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'accommodation id not found' }, status: :not_found
  end

  def available_rooms
    @check_in = params[:check_in]
    @check_out = params[:check_out]
    @number_of_peoples = params[:number_of_peoples]
    @available_rooms = Accommodation.joins(:rooms).where('places >= ?', @number_of_peoples)
                                    .where.not(id: booked_room_ids(@check_in, @check_out))
  end

  # Only allow a list of trusted parameters through.
  def accommodation_params
    params.permit(:name, :description, :address, :kind, :phone, :email, :status)
  end
end
