class Api::V1::AppointmentsController < ApplicationController
  before_action :set_user, except: %i[index_partner confirm cancel]
  before_action :set_tour, only: %i[index_partner confirm cancel]
  before_action :set_appointment, only: %i[show update destroy]
  before_action :set_partner, only: %i[confirm cancel]
  before_action :authorize_policy

  def index
    @appointments = @user.appointments.all.joins(:tour).where('time_end >= ?', Time.now)
    @appointments = @user.appointments.all.joins(:tour).where('time_end < ?', Time.now) if params[:archived].present?

    authorize @appointments
    if @appointments
      render json: { data: @appointments }, status: :ok
    else
      render json: @appointments.errors, status: :bad_request
    end
  end

  def index_partner
    @appointments = @tour.appointments.all.joins(:tour).where('time_end >= ?', Time.now)
    @appointments = @tour.appointments.all.joins(:tour).where('time_end < ?', Time.now) if params[:archived].present?

    authorize @appointments
    # authorize @tours, :index_partner?
    if @appointments
      render json: { data: @appointments }, status: :ok
    else
      render json: @appointments.errors, status: :bad_request
    end
  end

  def show
    authorize @appointment

    render json: @appointment, status: :ok
  end

  def create
    @tour = Tour.find_by_id(params[:tour_id])
    @appointment = @current_user.appointments.build(appointment_params)

    authorize @appointment

    if @appointment.save
      # AppointmentMailer.appointment_confirmation(@appointment.user, @appointment).deliver_now
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @appointment

    if @appointment.update(appointment_params.except(:confirmation))
      render json: { status: 'Update', data: @appointment }, status: :ok
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @appointment

    if @appointment.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def confirm
    authorize @appointment

    if @appointment.approved!
      render json: { status: 'Confirmed', data: @appointment }, status: :ok
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def cancel
    authorize @appointment

    if @appointment.cancelled!
      render json: { status: 'Cancelled', data: @appointment }, status: :ok
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_appointment
    @appointment = @user.appointments.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'appointment id not found' }, status: :not_found
  end

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'user id not found' }, status: :not_found
  end

  def set_tour
    @tour = Tour.find(params[:tour_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'tour id not found' }, status: :not_found
  end

  def set_partner
    @appointment = @tour.appointments.find(params[:appointment_id])
    @partner_id = @appointment.tour.user_id
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.permit(:number_of_peoples, :tour_id)
  end

  def authorize_policy
    authorize Appointment
    # authorize Tour
  end
end
