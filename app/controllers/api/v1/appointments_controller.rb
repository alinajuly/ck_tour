class Api::V1::AppointmentsController < ApplicationController
  before_action :set_user, except: :list_for_partner
  before_action :set_tour, only: :list_for_partner
  before_action :set_appointment, only: %i[show update destroy]
  before_action :authorize_policy

  def index
    user_appointments = @user.appointments
    @appointments = if params[:archived].present?
                      user_appointments.joins(:tour).where('time_end < ?', Time.now)
                    else
                      user_appointments.joins(:tour).where('time_end >= ?', Time.now)
                    end

    authorize @appointments
    if @appointments
      render json: { data: @appointments }, status: :ok
    else
      render json: @appointments.errors, status: :bad_request
    end
  end

  def list_for_partner
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
    @appointment = @current_user.appointments.build(permitted_attributes(Appointment))

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

    if @appointment.update(appointment_params)
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

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(policy(@appointment).permitted_attributes)
    # params.permit(:number_of_peoples, :tour_id)
  end

  def authorize_policy
    authorize Appointment
    # authorize Tour
  end
end
