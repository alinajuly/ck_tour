class Api::V1::BookingsController < ApplicationController
  include BookingableUtilities

  before_action :authorize_policy, only: %i[index list_for_partner]
  before_action :set_user, except: %i[create list_for_partner]
  before_action :set_accommodation, only: :list_for_partner
  before_action :set_room, only: %i[create list_for_partner]
  before_action :set_booking, only: %i[show update destroy]

  def index
    user_bookings = @user.bookings
    @bookings = if params[:archived].present?
                  policy_scope(user_bookings.archival_booking)
                else
                  policy_scope(user_bookings.upcoming_booking)
                end
    authorize @bookings

    if @bookings
      render json: { data: @bookings }, status: :ok
    else
      render json: @bookings.errors, status: :bad_request
    end
  end

  def show
    authorize @booking

    render json: @booking, status: :ok
  end

  def create
    @booking = @current_user.bookings.build(booking_params)

    authorize @booking

    if @booking.save
      BookingMailer.booking_confirmation(@booking.user, @booking).deliver_now
      BookingMailer.booking_tourist(@booking.user, @booking).deliver_now
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @booking

    if @booking.update(edit_booking_params)
      if @booking.approved? && params[:confirmation].present?
        BookingMailer.booking_approved(@booking.user, @booking).deliver_now
      elsif @booking.cancelled? && params[:confirmation].present?
        BookingMailer.booking_cancelled(@booking.user, @booking).deliver_now
      else
        BookingMailer.booking_updated_for_partner(@booking.user, @booking).deliver_now
        BookingMailer.booking_updated_for_tourist(@booking.user, @booking).deliver_now
      end
      render json: { status: 'Update', data: @booking }, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def destroy

    if @booking.destroy!
      BookingMailer.booking_deleted(@booking.user, @booking).deliver_now
      BookingMailer.booking_deleted_for_partner(@booking.user, @booking).deliver_now
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_accommodation
    @accommodation = Accommodation.find(params[:accommodation_id])
  end

  def set_room
    @room = Room.find_by_id(params[:room_id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:number_of_peoples, :check_in, :check_out, :note, :phone, :full_name, :room_id, :user_id)
  end

  def edit_booking_params
    params.permit(policy(@booking).permitted_attributes)
  end

  def authorize_policy
    authorize Booking
  end
end
