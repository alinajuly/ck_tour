class Api::V1::FacilitiesController < ApplicationController
  before_action :set_accommodation
  before_action :set_facility, only: %i[update destroy]
  skip_before_action :authenticate_request, only: %i[index]

  def index
    @facilities = @accommodation.facilities.all
    render json: @facilities, status: :ok
  end

  # POST /api/v1/facilities
  def create
    @facility = @accommodation.facilities.new(facility_params)
    if @facility.save
      render json: { data: @facility }, status: :created
    else
      render json: @facility.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/facilities/1
  def update
    if @facility.update(facility_params)
      render json: { status: 'Update', data: @facility }, status: :ok
    else
      render json: @facility.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/facilities/1
  def destroy
    if @facility.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @facility.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find_by_id(params[:accommodation_id])
  end

  def set_facility
    @facility = @accommodation.facilities
  end

  # Only allow a list of trusted parameters through.
  def facility_params
    params.permit(:checkin_start, :checkin_end, :checkout_start, :checkout_end, :credit_card, :free_parking,
                  :wi_fi, :breakfast, :pets)
  end
end
