class BookingMailer < ApplicationMailer
  def booking_confirmation(user, booking)
    @user = user
    @booking = booking
    @accommodation = @booking.room.accommodation
    mail(to: @accommodation.email, subject: 'Нове бронювання Вашого помешкання')
  end

  def booking_tourist(user, booking)
    @user = user
    @booking = booking
    @accommodation = @booking.room.accommodation
    @geolocation = Geolocation.find_by(geolocationable_id: @accommodation.id, geolocationable_type: 'Accommodation')
    mail(to: @user.email, subject: 'Ваше бронювання')
  end
end
