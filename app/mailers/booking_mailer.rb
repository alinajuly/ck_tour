class BookingMailer < ApplicationMailer
  before_action :logo_attach

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

  private

  def logo_attach
    attachments.inline['logo.svg'] = File.read((Rails.root.join('public', 'logo.svg')))
  end
end
