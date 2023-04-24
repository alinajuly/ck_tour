class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :authorize_policy
  before_action :set_user, only: %i[show update destroy]

  # GET api/v1/users
  def index
    @users = if params[:role].present?
               User.role_filter(params[:role])
             else
               User.all
             end

    authorize @users

    render json: @users, status: :ok
  end

  # GET api/v1/users/{name}
  def show
    authorize @user

    render json: @user, status: :ok
  end

  # POST api/v1/users
  def create
    @user = User.new(user_params)

    authorize @user

    if @user.save
      UserMailer.user_welcome(@user).deliver_later
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    authorize @user

    if @user.tourist?
      @user.partner!
      UserMailer.user_partner(@user).deliver_later

      render json: { status: 'Role is changed', data: @user }, status: :ok
    elsif @user.partner?
      @user.tourist!
      UserMailer.user_tourist(@user).deliver_later
      @user.accommodations.unpublished! if @user.accommodations.present?
      @user.tours.unpublished! if @user.tours.present?
      @user.caterings.unpublished! if @user.caterings.present?
      render json: { status: 'Role is changed, resources are hidden', data: @user }, status: :ok
    else
      render json: { error: 'Invalid current password' }, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/users/{name}
  def destroy
    authorize @user

    @user.destroy
  end

  # def update_role_after_payment
  #   if @user.subscription.status == 'trialing' || user.subscription.status == 'active'
  #     # Змінити роль користувача на 'partner'
  #     @user.update(role: 'partner')
  #     render json: { status: 'Role is changed, resources are hidden', data: @user }, status: :ok
  #   else
  #     render json: { error: 'Invalid current password' }, status: :unprocessable_entity
  #   end
  # end

  private

  def set_user
    @user = policy_scope(User).find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password)
  end

  def authorize_policy
    authorize User
  end
end
