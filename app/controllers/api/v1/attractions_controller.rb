class Api::V1::AttractionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show index search]
  before_action :authorize_policy
  before_action :set_attractions, only: :index
  before_action :set_attraction, only: %i[show update destroy]

  # GET /api/v1/attractions
  def index
    authorize @attractions

    if @attractions
      render json: @attractions.as_json(include: :geolocations, methods: [:image_url]), status: :ok
    else
      render json: @attractions.errors, status: :bad_request
    end
  end

  # GET /api/v1/attractions/1
  def show
    authorize @attraction

    render json: @attraction.as_json(include: :geolocations, methods: [:image_url]), status: :ok
  end

  # POST /api/v1/attractions
  def create
    @attraction = Attraction.new(attraction_params)

    authorize @attraction

    if @attraction.save
      render json: AttractionSerializer.new(@attraction).serializable_hash[:data][:attributes], status: :created
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/attractions/1
  def update
    authorize @attraction

    if @attraction.update(attraction_params)
      render json: AttractionSerializer.new(@attraction).serializable_hash[:data][:attributes], status: :ok
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/attractions/1
  def destroy
    authorize @attraction

    if @attraction.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  private

  def set_attractions
    @attractions = if params[:geolocations].present?
                     Attraction.geolocation_filter(params[:geolocations])
                   elsif params[:search].present?
                     Attraction.search_filter(params[:search])
                   else
                     Attraction.all
                   end
  end

  def set_attraction
    @attraction = Attraction.find(params[:id])
  end

  def attraction_params
    params.permit(:title, :description, :image)
  end

  def authorize_policy
    authorize Attraction
  end
end
