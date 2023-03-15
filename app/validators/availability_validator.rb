class AvailabilityValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    bookings = Booking.where(["room_id =?", record.room_id])
    date_ranges = bookings.map { |b| b.check_in..b.check_out }

    return unless room.quantity == 1

    date_ranges.each do |range|
      if range.include? value
        record.errors.add(attribute, 'not available')
      end
    end
  end
end
