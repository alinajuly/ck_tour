class Api::V1::ToursController < ApplicationController
  before_action :set_tour, only: %i[show update destroy]

  # GET /api/v1/tours
  def index
    @tours = Tour.all
    @tours = @tours.status_filter(params[:status]) if params[:status].present?

    authorize @tours

    if @tours
      render json: { data: @tours }, status: :ok
    else
      render json: @tours.errors, status: :bad_request
    end
  end

  # GET /api/v1/tours/1
  def show
    authorize @tour

    @places = @tour.places
    render json: { data: @tour, places: @places }, status: :ok
  end

  # POST /api/v1/tours
  def create
    @tour = Tour.new(tour_params)

    if @tour.save
      render json: @tour, status: :created
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tours/1
  def update
    if @tour.update(tour_params)
      render json: @tour
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tours/1
  def destroy
    @tour.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tour_params
    params.permit(:title, :description, :address_owner, :reg_code, :person, :seats, :price_per_one,
                  :time_start, :time_end, :phone, :email, :status, :user_id)
  end

  def authorize_policy
    authorize Tour
  end
end
