class Api::V1::RatesController < ApplicationController
  include ResourceFinder
  skip_before_action :authenticate_request, only: :show
  before_action :current_user, only: :show
  before_action :set_rate, only: %i[update destroy]
  before_action :authorize_policy
  
  # GET /api/v1/rates/1
  def show
    @rate = policy_scope(parentable.rates).find(params[:id])

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
    authorize @rate

    if @rate.destroy
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @rate.errors, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rate
    # @rate = parentable.rates.find(params[:id])
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
