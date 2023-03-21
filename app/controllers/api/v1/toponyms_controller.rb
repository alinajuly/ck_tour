class Api::V1::ToponymsController < ApplicationController
  include ResourceFinder
  skip_before_action :authenticate_request, only: %i[show index]
  before_action :set_toponym, only: %i[update destroy]
  before_action :authorize_policy

  # GET /api/v1/toponyms
  def index
    @toponyms = Toponym.all

    authorize @toponyms

    render json: @toponyms
  end

  # GET /api/v1/toponyms/1
  def show
    @toponym = parentable.toponyms

    authorize @toponym

    render json: @toponym
  end

  # POST /api/v1/toponyms
  def create
    @toponym = parentable.toponyms.new(toponym_params)

    authorize @toponym

    if @toponym.save
      render json: @toponym, status: :created
    else
      render json: @toponym.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/toponyms/1
  def update
    authorize @toponym

    if @toponym.update(toponym_params)
      render json: @toponym
    else
      render json: @toponym.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/toponyms/1
  def destroy
    authorize @toponym

    @toponym.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_toponym
    @toponym = parentable.toponyms.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def toponym_params
    params.permit(:locality)
  end

  def authorize_policy
    authorize Coordinate
  end
end