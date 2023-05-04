class BookingMailer < ApplicationMailer
  def booking_confirmation(user, booking)
    set_mail_variables(user, booking)
    mail(to: @accommodation.email, subject: 'Нове бронювання Вашого помешкання')
  end

  def booking_tourist(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Ваше бронювання')
  end

  def booking_approved(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Підтвердження Вашого бронювання')
  end

  def booking_cancelled(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Скасування Вашого бронювання')
  end

  def booking_updated_for_partner(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Зміна в бронюванні Вашого помешкання')
  end

  def booking_updated_for_tourist(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Зміна в Вашому бронюванні')
  end

  def booking_deleted(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Скасування Вашого бронювання')
  end

  def booking_deleted_for_partner(user, booking)
    set_mail_variables(user, booking)
    mail(to: @user.email, subject: 'Скасування бронювання у Вашому помешканні')
  end

  private

  def set_mail_variables(user, booking)
    @user = user
    @booking = booking
    @accommodation = @booking.room.accommodation
    @geolocation = Geolocation.find_by(geolocationable_id: @accommodation.id, geolocationable_type: 'Accommodation')
  end
end
