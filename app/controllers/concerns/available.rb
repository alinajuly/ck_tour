module Available
  extend ActiveSupport::Concern

  def available_rooms
    check_in = params[:check_in].to_date
    check_out = params[:check_out].to_date
    number_of_peoples = params[:number_of_peoples]
    # select rooms ids of current accommodation
    allowed_ids = @accommodation.rooms.pluck(:id)
    # select rooms ids and date ranges where rooms are booked
    date_ranges = Booking.upcoming_booking.map { |b| [b.room_id, b.check_in...b.check_out] }
    # select booked rooms of current accommodation
    rooms_date_ranges = date_ranges.select { |sub_arr| allowed_ids.include?(sub_arr[0]) }
    # select booked room ids (regardless of room quantity) overlaping with new booking date range in query
    raw_rooms_ids = rooms_date_ranges.select { |array| array[1].overlaps?(check_in...check_out) }
                                     .map(&:first)
    # add room quantities to raw_rooms_ids
    room_ids_with_quantities = raw_rooms_ids.map { |id| [id, Room.find_by(id: id).quantity] }
    # select booked room ids (regard of room quantity with same id) overlaping with new booking date range in query
    booked_room_ids = []
    room_ids_with_quantities.group_by { |r| r[0] }.each do |room_id, room_quantities|
      total_quantity = room_quantities.sum { |r| r[1] }
      if total_quantity >= room_quantities.map(&:second).uniq.sum
        booked_room_ids << room_id
      end
    end

    # counting how many free places are left in accommodation
    free_places = @accommodation.rooms.where.not(id: booked_room_ids).pluck(:places).sum

    # nil rooms if free places are not enough
    return if free_places < number_of_peoples.to_i

    # list of free rooms for booking
    @accommodation.rooms.where.not(id: booked_room_ids)
  end
end
