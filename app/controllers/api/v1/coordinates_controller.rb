class Api::V1::CoordinatesController < ApplicationController
  include ResourceFinder
  before_action :set_coordinate, only: %i[show update destroy]
  skip_before_action :authenticate_request, only: %i[show]
  before_action :authorize_policy

  def show
    authorize @coordinate

    render json: @coordinate
  end

  def create
    @coordinate = parentable.coordinates.new(coordinate_params)

    authorize @coordinate

    if @coordinate.save
      render json: @coordinate, status: :created
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @coordinate

    if @coordinate.update(coordinate_params)
      render json: { status: 'Update', data: @coordinate }, status: :ok
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @coordinate
    
    if @coordinate.destroy!
      render json: { status: 'Delete' }, status: :no_content
    else
      render json: @coordinate.errors, status: :unprocessable_entity
    end
  end

  private

  def set_coordinate
    @coordinate = parentable.coordinates
  end

  def coordinate_params
    params.permit(:latitude, :longitude)
  end

  def authorize_policy
    authorize Coordinate
  end
end
