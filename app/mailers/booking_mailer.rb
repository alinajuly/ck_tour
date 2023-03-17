class BookingMailer < ApplicationMailer
  def booking_confirmation(user, booking)
    @user = user
    @booking = booking
    @accommodation = @booking.room.accommodation
    mail(to: @accommodation.email, subject: 'New booking confirmation')
  end
end
