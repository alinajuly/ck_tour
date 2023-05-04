module BookingableUtilities
  extend ActiveSupport::Concern

  def list_for_partner
    room_bookings = @room.bookings
    @bookings = if params[:archived].present?
                  policy_scope(room_bookings.archival_booking)
                else
                  policy_scope(room_bookings.upcoming_booking)
                end

    if @bookings
      render json: { data: @bookings }, status: :ok
    else
      render json: @bookings.errors, status: :bad_request
    end
  end
end
