class Api::V1::ToursController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :set_tour, only: :show
  before_action :edit_tour, only: %i[update destroy]
  before_action :authorize_policy

  # GET /api/v1/tours
  def index
    @tours = if params[:geolocations].present?
               policy_scope(Tour).geolocation_filter(params[:geolocations])
             elsif params[:user_id].present?
               policy_scope(Tour).filter_by_partner(params[:user_id])
             elsif params[:status].present?
               policy_scope(Tour).filter_by_status(params[:status])
             elsif params[:archived].present?
               policy_scope(Tour).archival_tours
             else
               policy_scope(Tour).upcoming_tours
             end

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

    render json: TourSerializer.new(@tour).as_json(include: { places: { methods: [:image_url] }})
  end

  # POST /api/v1/tours
  def create
    @tour = Tour.new(permitted_attributes(Tour))

    authorize @tour

    if @tour.save
      render json: TourSerializer.new(@tour), status: :created
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tours/1
  def update
    authorize @tour

    if @tour.update(tour_params)
      if @tour.published? && params[:status].present?
        StatusMailer.tour_published(@tour.user, @tour).deliver_later
      end
      render json: TourSerializer.new(@tour), status: :ok
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
