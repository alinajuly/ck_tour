class Api::V1::BookingsController < ApplicationController
  before_action :set_user
  before_action :set_room
  before_action :set_booking, only: %i[show update destroy]

  def index
    @bookings = @user.bookings
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
    def create
      # Retrieve the booking parameters from the request body
      check_in = Date.parse(params[:check_in])
      check_out = Date.parse(params[:check_out])
      number_of_people = params[:number_of_people].to_i

      # Check if the room is available for the selected dates
      if room.available?(check_in, check_out)
        # If the room is available, create a new booking
        booking = Booking.new(
          room: @room,
          user: @user,
          check_in: check_in,
          check_out: check_out,
          number_of_people: number_of_people,
        )

        # Save the booking to the database
        if booking.save
          # If the booking is saved successfully, return a success response
          render json: booking, status: :created
        else
          # If there was an error saving the booking, return an error response
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      else
        # If the room is not available, return an error response
        render json: { error: 'Room is not available for the selected dates' }, status: :unprocessable_entity
      end
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

  def set_user
    @user = User.find_by_id(params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'user id not found' }, status: :not_found
  end

  def set_room
    @room = Room.find_by_id(params[:room_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'room id not found' }, status: :not_found
  end

  def set_booking
    @booking = Booking.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'booking id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:number_of_peoples, :check_in, :check_out, :note, :confirmation)
  end
end
