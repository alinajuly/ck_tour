class Api::V1::PasswordResetsController < ApplicationController
  def password_reset
    token = params[:token]
    payload = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    user = User.find(payload['user_id'])
    user.update(password: params[:password])
    PasswordResetToken.where(token: token).destroy_all
    render json: { message: 'Password reset successful.' }, status: :ok
  rescue JWT::ExpiredSignature, JWT::VerificationError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid token.' }, status: :unprocessable_entity
  end
end
