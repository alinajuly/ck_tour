class AppointmentMailer < ApplicationMailer
  def appointment_confirmation(user, appointment)
    @user = user
    @appointment = appointment
    @tour = appointment.tour
    mail(to: @tour.email, subject: 'Нове замовлення Вашого туру')
  end

  def appointment_tourist(user, appointment)
    @user = user
    @appointment = appointment
    @tour = appointment.tour
    mail(to: @user.email, subject: 'Ваше замовлення туру')
  end

  def appointment_approved(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    @geolocation = Geolocation.find_by(geolocationable_id: @tour.id, geolocationable_type: 'Tour')
    mail(to: @user.email, subject: 'Підтвердження Вашого замовлення')
  end

  def appointment_cancelled(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    @geolocation = Geolocation.find_by(geolocationable_id: @tour.id, geolocationable_type: 'Tour')
    mail(to: @user.email, subject: 'Скасування Вашого замовлення')
  end

  def appointment_updated_for_partner(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    mail(to: @user.email, subject: 'Зміна в замовленні Вашого туру')
  end

  def appointment_updated_for_tourist(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    @geolocation = Geolocation.find_by(geolocationable_id: @tour.id, geolocationable_type: 'Tour')
    mail(to: @user.email, subject: 'Зміна в Вашому замовленні')
  end

  def appointment_deleted(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    mail(to: @user.email, subject: 'Скасування Вашого замовлення')
  end

  def appointment_deleted_for_partner(user, appointment)
    @user = user
    @appointment = appointment
    @tour = @appointment.tour
    mail(to: @user.email, subject: 'Скасування замовлення Вашого туру')
  end
end
