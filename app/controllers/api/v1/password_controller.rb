module Api::V1
  class PasswordController < ApplicationController
    skip_before_action :authenticate_request
    def forgot
      return render json: { error: 'Email not present' } if params[:email].blank? # check if email is present

      user = User.find_by(email: params[:email]) # if present find user by email

      if user.present?
        user.generate_password_token! # generate pass token
        PasswordResetMailer.with(user:).password_reset.deliver_now
        render json: { reset_password_token: user.reset_password_token }, status: :ok
        # render json: { status: 'We will send you password reset instructions as soon as we find you in the database' }, status: :ok
      else
        render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
      end
    end

    def reset
      token = params[:token]

      return render json: { error: 'Token not present' } if params[:email].blank?

      user = User.find_by(reset_password_token: token)

      if user.present? && user.password_token_valid?
        if user.reset_password!(params[:password])
          render json: { status: 'ok' }, status: :ok
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
      end
    end
  end
end
