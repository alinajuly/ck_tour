class ReservationMailer < ApplicationMailer
  def reservation_confirmation(user, reservation)
    @user = user
    @reservation = reservation
    @catering = @reservation.catering
    mail(to: @catering.email, subject: 'Нова резервація у Вашому закладі')
  end

  def reservation_tourist(user, reservation)
    @user = user
    @reservation = reservation
    @catering = @reservation.catering
    @geolocation = Geolocation.find_by(geolocationable_id: @catering.id, geolocationable_type: 'Catering')
    mail(to: @user.email, subject: 'Ваше резервування')
  end
end
