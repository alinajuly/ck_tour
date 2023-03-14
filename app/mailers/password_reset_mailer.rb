class PasswordResetMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    mail(to: @user.email, subject: 'Reset Your Password')
  end
end
