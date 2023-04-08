class Api::V1::PlacesController < ApplicationController
  before_action :set_tour
  before_action :set_place, only: %i[show update destroy]

  def index
    @places = @tour.places.joins(:image_attachment)

    authorize @places
    # render json: @places.as_json(include: :geolocations), status: :ok
    render json: @places.map { |place|
      place.as_json(only: %i[id name body tour_id], include: :geolocations)
           .merge(image_path: url_for(place.image)) }
  end

  def show
    authorize @place

    # render json: @place.as_json(include: :geolocations), status: :ok
    if @place.image.attached?
      # render json: @place.as_json(only: %i[id name body tour_id]).merge(
      #   image_path: url_for(@place.image))
      render json: @place.as_json(only: %i[id name body tour_id], include: :geolocations)
                         .merge(image_path: url_for(@place.image))
    else
      render json: @place.as_json(only: %i[id name body tour_id], include: :geolocations)
    end
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

    if @place.update(place_params)
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
    params.permit(:name, :body, :tour_id, :image)
  end
end
