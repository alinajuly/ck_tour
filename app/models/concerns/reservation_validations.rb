module ReservationValidations
  extend ActiveSupport::Concern

  def not_in_past
    # validate on upcoming of check_in and check_out dates
    errors.add(:check_in, "can't be in the past") if check_in.present? && check_in <= Time.now
    errors.add(:check_out, "can't be in the past") if check_out.present? && check_out < Time.now
  end

  def enough_places
    # array with time ranges when selected catering is reserved in future
    time_ranges = catering.reservations.upcoming_reservation.map { |r| [r.number_of_peoples, r.check_in...r.check_out] }
    # time range for new reservation
    reservation_range = (check_in...check_out)
    # the number of reserved seats for the selected time
    reserved_places = time_ranges.select { |array| array[1].overlaps? reservation_range }
                                 .map(&:first).sum
    # the number of free seats for the selected time
    free_places = catering.places - reserved_places

    # pass validation if catering places are enough for guests
    return if number_of_peoples <= free_places

    errors.add(:catering, 'is not enough places in the selected restaurant for the selected times')
  end
end
