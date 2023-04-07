class Api::V1::ReservationsController < ApplicationController
  before_action :set_user, except: :list_for_partner
  before_action :set_catering, only: :list_for_partner
  before_action :set_reservation, only: %i[show update destroy]
  before_action :authorize_policy

  def index
    @reservations = @user.reservations.where('check_out >= ?', Time.now)
    @reservations = @user.reservations.where('check_out < ?', Time.now) if params[:archived].present?

    authorize @reservations
    if @reservations
      render json: { data: @reservations }, status: :ok
    else
      render json: @reservations.errors, status: :bad_request
    end
  end

  def list_for_partner
    # @reservation = Reservation.joins(catering: :accommodation).where()
    @reservations = @catering.reservations.where('check_out >= ?', Time.now)
    @reservations = @catering.reservations.where('check_out < ?', Time.now) if params[:archived].present?

    authorize @reservations
    if @reservations
      render json: { data: @reservations }, status: :ok
    else
      render json: @reservations.errors, status: :bad_request
    end
  end

  def show
    authorize @reservation

    render json: @reservation, status: :ok
  end

  def create
    @catering = Catering.find_by_id(params[:catering_id])
    @reservation = @current_user.reservations.build(permitted_attributes(Reservation))

    authorize @reservation

    if @reservation.save
      # ReservationMailer.reservation_confirmation(@reservation.user, @reservation).deliver_now
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @reservation

    if @reservation.update(reservation_params)
      render json: { status: 'Update', data: @reservation }, status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @reservation

    if @reservation.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  private

  def set_reservation
    @reservation = @user.reservations.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'reservation id not found' }, status: :not_found
  end

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'user id not found' }, status: :not_found
  end

  def set_catering
    @catering = Catering.find(params[:catering_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'catering id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def reservation_params
    params.require(:reservation).permit(policy(@reservation).permitted_attributes)
    # params.permit(:number_of_peoples, :check_in, :check_out, :note, :catering_id)
  end

  def authorize_policy
    authorize Reservation
  end
end
