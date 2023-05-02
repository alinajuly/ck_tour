module AppointmentableUtilities
  extend ActiveSupport::Concern
  
  def list_for_partner
    tour_appointments = @tour.appointments
    @appointments = if params[:archived].present?
                      policy_scope(tour_appointments.archival_appointment)
                    else
                      policy_scope(tour_appointments.upcoming_appointment)
                    end

    if @appointments
      render json: { data: @appointments }, status: :ok
    else
      render json: @appointments.errors, status: :bad_request
    end
  end
end
