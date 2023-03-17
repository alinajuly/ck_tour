class Api::V1::BookingsController < ApplicationController
  before_action :authenticate_request
  before_action :set_booking, only: %i[show update destroy]

  def index
    @bookings = @current_user.bookings
    if @bookings
      render json: { data: @bookings }, status: :ok
    else
      render json: @bookings.errors, status: :bad_request
    end
  end

  def show
    render json: @booking, status: :ok
  end

  def create
    # @accommodation = Accommodation.find_by_id(params[:accommodation_id])
    @room = Room.find_by_id(params[:room_id])
    @booking = @current_user.bookings.build(booking_params)
    if @booking.save
      BookingMailer.booking_confirmation(@booking.user, @booking).deliver_now
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(room_params)
      render json: { status: 'Update', data: @booking }, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @booking.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'booking id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:number_of_peoples, :check_in, :check_out, :note, :confirmation, :room_id)
  end
end
