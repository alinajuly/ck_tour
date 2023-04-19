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
end
