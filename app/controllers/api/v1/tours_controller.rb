class Api::V1::ToursController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_tour, only: %i[update destroy]
  before_action :set_for_publish, only: %i[publish unpublish]
  before_action :authorize_policy

  # GET /api/v1/tours
  def index
    @tours = Tour.all.where('time_start >= ?', Time.now).published
    @tours = Tour.geolocation_filter(params[:geolocations]).published if params[:geolocations].present?
    @tours = Tour.where(params[:user_id]).published if params[:user_id].present?
    @tours = Tour.all.where('time_start < ?', Time.now).published if params[:archived].present?

    authorize @tours

    if @tours
      render json: { data: @tours }, status: :ok
    else
      render json: @tours.errors, status: :bad_request
    end
  end

  def index_unpublished
    @tours = policy_scope(Tour).all.unpublished

    authorize @tours

    if @tours
      render json: { data: @tours }, status: :ok
    else
      render json: @tours.errors, status: :bad_request
    end
  end

  # GET /api/v1/tours/1
  def show
    @tour = Tour.find(params[:id]) if Tour.find(params[:id]).published?
    if @tour.present?
      authorize @tour

      @places = @tour.places
      render json: { data: @tour, places: @places }, status: :ok
    else
      render json: { message: 'tour id not found' }, status: :not_found
    end
  end

  def show_unpublished
    @tour = policy_scope(Tour).find(params[:tour_id])

    authorize @tour

    if @tour
      render json: { data: @tour }, status: :ok
    else
      render json: @tour.errors, status: :bad_request
    end
  end

  # POST /api/v1/tours
  def create
    @tour = Tour.new(tour_params)

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

    if @tour.update(tour_params.except(:status))
      render json: { status: 'Item is published', data: @tour }, status: :ok
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  def publish
    authorize @tour

    if @tour.published!
      render json: { status: 'Item is published', data: @tour }, status: :ok
    else
      render json: @tour.errors, status: :unprocessable_entity
    end
  end

  def unpublish
    authorize @tour

    if @tour.unpublished!
      render json: { status: 'Item is hidden', data: @tour }, status: :ok
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
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'tour id not found' }, status: :not_found
  end

  def set_for_publish
    @tour = Tour.find(params[:tour_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'tour id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def tour_params
    params.permit(:title, :description, :address_owner, :reg_code, :person, :seats, :price_per_one,
                  :time_start, :time_end, :phone, :email, :user_id)
  end

  def authorize_policy
    authorize Tour
  end
end
