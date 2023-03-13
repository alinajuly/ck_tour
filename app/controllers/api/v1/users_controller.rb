class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :destroy]

  # GET api/v1/users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET api/v1/users/{name}
  def show
    render json: @user, status: :ok
  end

  # POST api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT api/v1/users/{name}
  def update
    if user&.authenticate(params[:current_password])
      user.update(password: params[:new_password])
      render json: { message: 'Password updated successfully' }, status: :ok
    else
      render json: { error: 'Invalid current password' }, status: :unprocessable_entity
    end
    # unless @user.update(user_params)
    #   render json: { errors: @user.errors.full_messages },
    #          status: :unprocessable_entity
    # end
  end

  # DELETE api/v1/users/{name}
  def destroy
    @user.destroy
  end

  def password_reset
    user = User.find_by(email: params[:email])
    if user
      token = user.generate_password_reset_token
      PasswordResetMailer.with(user: user, token: token).password_reset.deliver_now
      render json: { message: 'Password reset email sent.' }, status: :ok
    else
      render json: { error: 'Email not found.' }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
