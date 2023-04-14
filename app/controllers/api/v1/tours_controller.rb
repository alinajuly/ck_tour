class Api::V1::ToursController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :set_tour, only: :show
  before_action :edit_tour, only: %i[update destroy]
  before_action :authorize_policy

  # GET /api/v1/tours
  def index
    @tours = policy_scope(Tour).where('time_start >= ?', Time.now)
    @tours = policy_scope(Tour).geolocation_filter(params[:geolocations]) if params[:geolocations].present?
    @tours = policy_scope(Tour).where(user_id: params[:user_id]) if params[:user_id].present?
    @tours = policy_scope(Tour).where(status: params[:status]) if params[:status].present?
    @tours = policy_scope(Tour).where('time_start < ?', Time.now) if params[:archived].present?

    authorize @tours

    if @tours
      render json: @tours.as_json(include: { places: { methods: [:image_url] }})
    else
      render json: @tours.errors, status: :bad_request
    end
  end

  # GET /api/v1/tours/1
  def show
    authorize @tour

    render json: @tour.as_json(include: { places: { methods: [:image_url] }})
  end

  # POST /api/v1/tours
  def create
    @tour = Tour.new(permitted_attributes(Tour))

    authorize @tour

    if @tour.save
      render json: @tour, status: :created
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tours/1
  def update
    authorize @tour

    if @tour.update(tour_params)
      render json: { status: 'Update', data: @tour }, status: :ok
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tours/1
  def destroy
    authorize @tour

    if @tour.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = policy_scope(Tour).find(params[:id])
  end

  def edit_tour
    @tour = TourPolicy::EditScope.new(current_user, Tour).resolve.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tour_params
    params.permit(policy(@tour).permitted_attributes)
  end

  def authorize_policy
    authorize Tour
  end
end
