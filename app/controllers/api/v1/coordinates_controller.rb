class Api::V1::CoordinatesController < ApplicationController
  before_action :set_coordinate, only: %i[show destroy]
  skip_before_action :authenticate_request, only: %i[show]
  include ResourceFinder

  def show
    render json: @coordinate
  end

  def create
    @coordinate = parentable.coordinates.new(coordinate_params)
    if @coordinate.save
      render json: @coordinate, status: :created
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  def update
    if @coordinate.update(coordinate_params)
      render json: { status: 'Update', data: @coordinate }, status: :ok
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @coordinate.destroy!
      render json: { status: 'Delete' }, status: :no_content
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  private

  def set_coordinate
    @coordinate = parentable.coordinates.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'coordinate id not found' }, status: :not_found
  end

  def coordinate_params
    params.permit(:latitude, :longitude)
  end
end
