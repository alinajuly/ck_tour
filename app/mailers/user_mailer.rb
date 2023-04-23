class UserMailer < ApplicationMailer
  def user_welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Вітаємо на Черкаському туристичному порталі')
  end

  def user_partner(user)
    @user = user
    mail(to: @user.email, subject: 'Вітаємо нового Партнера')
  end

  def user_tourist(user)
    @user = user
    mail(to: @user.email, subject: 'Зміна статусу користувача')
  end
end
