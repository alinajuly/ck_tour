class Api::V1::PlacesController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_tour
  before_action :set_place, only: %i[show update destroy]

  def index
    @places = @tour.places

    authorize @places

    if @places
      render json: @places.as_json(include: :geolocations, methods: [:image_url]), status: :ok
    else
      render json: @places.errors, status: :bad_request
    end
  end

  def show
    authorize @place

    place_json
  end

  def create
    @place = @tour.places.new(place_params)

    authorize @place

    if @place.save
      place_json
    else
      render json: @place.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @place

    if @place.update(place_params)
      place_json
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
  end

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.permit(:name, :body, :tour_id, :image)
  end
end
