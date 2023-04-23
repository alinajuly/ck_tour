class StatusMailer < ApplicationMailer
  def accommodation_published(user, accommodation)
    @user = user
    @accommodation = accommodation
    mail(to: @user.email, subject: 'Публікацію Вашого помешкання схвалено адміністратором')
  end

  def catering_published(user, catering)
    @user = user
    @catering = catering
    mail(to: @user.email, subject: 'Публікацію Вашого закладу схвалено адміністратором')
  end

  def tour_published(user, tour)
    @user = user
    @tour = tour
    mail(to: @user.email, subject: 'Публікацію Вашого туру схвалено адміністратором')
  end
end
