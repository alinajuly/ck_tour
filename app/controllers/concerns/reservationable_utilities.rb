module ReservationableUtilities
  extend ActiveSupport::Concern
  
  def list_for_partner
    catering_reservations = @catering.reservations
    @reservations = if params[:archived].present?
                      policy_scope(catering_reservations.archival_reservation)
                    else
                      policy_scope(catering_reservations.upcoming_reservation)
                    end

    if @reservations
      render json: { data: @reservations }, status: :ok
    else
      render json: @reservations.errors, status: :bad_request
    end
  end
end
