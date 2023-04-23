class ReservationMailer < ApplicationMailer
  def reservation_confirmation(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @catering.email, subject: 'Нова резервація у Вашому закладі')
  end

  def reservation_tourist(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Ваше резервування')
  end

  def reservation_approved(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Підтвердження Вашого резервування')
  end

  def reservation_cancelled(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Скасування Вашого резервування')
  end

  def reservation_updated_for_partner(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Зміна в резервуванні у Вашому закладі')
  end

  def reservation_updated_for_tourist(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Зміна в Вашому резервуванні')
  end

  def reservation_deleted(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Скасування Вашого резервування')
  end

  def reservation_deleted_for_partner(user, reservation)
    set_mail_variables(user, reservation)
    mail(to: @user.email, subject: 'Скасування резервування у Вашому закладі')
  end

  private

  def set_mail_variables(user, reservation)
    @user = user
    @reservation = reservation
    @catering = @reservation.catering
    @geolocation = Geolocation.find_by(geolocationable_id: @catering.id, geolocationable_type: 'Catering')
  end
end
