class Api::V1::SubscriptionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show create update]
  # skip_before_action :authenticate_request
  before_action :set_subscription, except: %i[index create]

  def index
    @subscriptions = Subscription.all
    
    if @subscriptions
      render json: { data: @subscriptions }, status: :ok
    else
      render json: @subscriptions.errors, status: :bad_request
    end
  end

  def show
    render json: @subscription, status: :ok
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      render json: { status: 'Create', data: @subscription }, status: :ok
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # cancel subscription by partner
  def update
    if @subscription.update(subscription_params)
      render json: { status: 'Update', data: @subscription }, status: :ok
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @subscription.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  private
  
  def set_subscription
    @subscription = Subscription.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'subscription id not found' }, status: :not_found
  end

  def subscription_params
    params.require(:data).permit(:card_number, :exp_month, :exp_year, :cvc, :user_id, :plan_id, :active, :trial_period_days)
  end
end
