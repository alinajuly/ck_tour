class AppointmentMailer < ApplicationMailer
  def appointment_confirmation(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @tour.email, subject: 'Нове замовлення Вашого туру')
  end

  def appointment_tourist(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Ваше замовлення туру')
  end

  def appointment_approved(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Підтвердження Вашого замовлення')
  end

  def appointment_cancelled(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Скасування Вашого замовлення')
  end

  def appointment_updated_for_partner(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Зміна в замовленні Вашого туру')
  end

  def appointment_updated_for_tourist(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Зміна в Вашому замовленні')
  end

  def appointment_deleted(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Скасування Вашого замовлення')
  end

  def appointment_deleted_for_partner(user, appointment)
    set_mail_variables(user, appointment)
    mail(to: @user.email, subject: 'Скасування замовлення Вашого туру')
  end

  private

  def set_mail_variables(user, appointment)
    @user = user
    @appointment = appointment
    @tour = appointment.tour
  end
end
