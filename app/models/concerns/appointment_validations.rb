module AppointmentValidations
  extend ActiveSupport::Concern

  def enough_seats
    return unless number_of_peoples > tour.seats - tour.appointments.where.not(id:)
                                                       .pluck(:number_of_peoples).sum

    errors.add(:tour, 'is not enough free seats in the selected tour')
  end
end
