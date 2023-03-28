class Api::V1::PlacesController < ApplicationController
  before_action :set_tour
  before_action :set_place, only: %i[show update destroy]

  def index
    @places = @tour.places.all

    authorize @places
    render json: @places.as_json(include: :geolocations), status: :ok
  end

  def show
    authorize @place

    render json: @place.as_json(include: :geolocations), status: :ok
  end

  def create
    @place = @tour.places.new(place_params)

    authorize @place

    if @place.save
      render json: { data: @place }, status: :created
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @place

    if @place.update(attraction_params)
      render json: { status: 'Update', data: @place }, status: :ok
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @place

    if @place.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  private

  def set_tour
    @tour = Tour.find_by_id(params[:tour_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'tour id not found' }, status: :not_found
  end

  def set_place
    @place = Place.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'place id not found' }, status: :not_found
  end

  def place_params
    params.permit(:name, :body, :tour_id)
  end
end
