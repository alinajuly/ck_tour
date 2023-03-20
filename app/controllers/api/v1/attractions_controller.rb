class Api::V1::AttractionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[show index search]
  before_action :set_attraction, only: %i[show update destroy]

  # GET /api/v1/attractions
  def index
    @attractions = if params[:toponyms].present?
                     attraction.toponym_filter(params[:toponyms])
                   else
                     Attraction.all
                   end
    if @attractions
      # render json: { data: @attractions }, status: :ok
      render json: @attractions.as_json(include: :coordinates), status: :ok
    else
      render json: @attractions.errors, status: :bad_request
    end
  end

  # GET /api/v1/attractions/1
  def show
    render json: @attraction.as_json(include: :coordinates), status: :ok
    # render json: @attraction.as_json(include: :toponyms), status: :ok
  end

  # POST /api/v1/attractions
  def create
    @attraction = Attraction.new(attraction_params)
    if @attraction.save
      render json: { data: @attraction }, status: :created
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/attractions/1
  def update
    if @attraction.update(attraction_params)
      render json: { status: 'Update', data: @attraction }, status: :ok
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/attractions/1
  def destroy
    if @attraction.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @attraction.errors, status: :unprocessable_entity
    end
  end

  def search
    @result = Attraction.all.joins(:toponyms).where('title||description||locality ILIKE ?', "%#{params[:req]}%")
    if @result.blank?
      render json: { message: 'Attraction not found' }, status: :ok
    else
      render json: { data: @result }, status: :ok
    end
  end

  private

  def set_attraction
    @attraction = Attraction.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'attraction id not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def attraction_params
    params.permit(:title, :description)
  end
end
