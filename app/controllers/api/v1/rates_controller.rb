class Api::V1::RatesController < ApplicationController
  before_action :set_api_v1_rate, only: %i[show update destroy]

  # GET /api/v1/rates
  def index
    @api_v1_rates = Api::V1::Rate.all

    render json: @api_v1_rates
  end

  # GET /api/v1/rates/1
  def show
    render json: @api_v1_rate
  end

  # POST /api/v1/rates
  def create
    @api_v1_rate = Api::V1::Rate.new(api_v1_rate_params)

    if @api_v1_rate.save
      render json: @api_v1_rate, status: :created, location: @api_v1_rate
    else
      render json: @api_v1_rate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/rates/1
  def update
    if @api_v1_rate.update(api_v1_rate_params)
      render json: @api_v1_rate
    else
      render json: @api_v1_rate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/rates/1
  def destroy
    @api_v1_rate.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_rate
      @api_v1_rate = Api::V1::Rate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_rate_params
      params.fetch(:api_v1_rate, {})
    end
end
