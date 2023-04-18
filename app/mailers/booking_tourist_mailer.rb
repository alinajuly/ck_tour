class BookingTouristMailer < ApplicationMailer
  def booking_tourist(user, booking)
    @user = user
    @booking = booking
    @accommodation = @booking.room.accommodation
    mail(to: @user.email, subject: 'Your new booking')
  end
end
