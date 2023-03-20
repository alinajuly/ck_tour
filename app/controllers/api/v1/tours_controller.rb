class Api::V1::ToursController < ApplicationController
  before_action :set_api_v1_tour, only: %i[show update destroy]

  # GET /api/v1/tours
  def index
    @api_v1_tours = Api::V1::Tour.all

    render json: @api_v1_tours
  end

  # GET /api/v1/tours/1
  def show
    render json: @api_v1_tour
  end

  # POST /api/v1/tours
  def create
    @api_v1_tour = Api::V1::Tour.new(api_v1_tour_params)

    if @api_v1_tour.save
      render json: @api_v1_tour, status: :created, location: @api_v1_tour
    else
      render json: @api_v1_tour.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tours/1
  def update
    if @api_v1_tour.update(api_v1_tour_params)
      render json: @api_v1_tour
    else
      render json: @api_v1_tour.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tours/1
  def destroy
    @api_v1_tour.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_tour
      @api_v1_tour = Api::V1::Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_tour_params
      params.fetch(:api_v1_tour, {})
    end
end
