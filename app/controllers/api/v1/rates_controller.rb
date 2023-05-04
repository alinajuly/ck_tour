class Api::V1::RatesController < ApplicationController
  include ResourceFinder
  before_action :current_user, only: :show
  before_action :authorize_policy
  before_action :set_rate, only: %i[update destroy]
  skip_before_action :authenticate_request, only: %i[index show]

  # GET /api/v1/rates
  def index
    average_rating = parentable.rates.average(:rating)

    @rates = if average_rating.nil?
               0
             else
               average_rating.round(1)
             end

    render json: @rates, status: :ok
  end

  # GET /api/v1/rates/1
  def show
    @rate = parentable.rates.find(params[:id])

    @rate.rating = 0 if @rate.rating.nil?

    render json: @rate, status: :ok
  end

  # POST /api/v1/rates
  def create
    @rate = parentable.rates.new(rate_params)

    if @rate.save
      render json: @rate, status: :created
    else
      render json: @rate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/rates/1
  def update
    if @rate.update(rate_params)
      render json: @rate, status: :ok
    else
      render json: @rate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/rates/1
  def destroy
    if @rate.destroy
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @rate.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rate
    @rate = policy_scope(parentable.rates, policy_scope_class: RatePolicy::Scope).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rate_params
    params.require(:rate).permit(:rating, :user_id, :ratable_id, :ratable_type).merge(user_id: current_user.id)
  end

  def authorize_policy
    authorize parentable.rates
  end
end
