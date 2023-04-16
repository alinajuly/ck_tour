class Api::V1::AccommodationsController < ApplicationController
  include Rails.application.routes.url_helpers
  include Available

  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :authorize_policy
  before_action :set_accommodations, only: :index
  before_action :set_accommodation, only: :show
  before_action :edit_accommodation, only: %i[update destroy]

  # GET /api/v1/accommodations
  def index

    if @accommodations
      render json: { data: @accommodations.map { |accommodation| accommodation.as_json.merge(images: accommodation.images.map { |image| url_for(image) }) } }, status: :ok
    else
      render json: @accommodations.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1
  def show
    authorize @accommodation

    @rooms = @accommodation.rooms
    render json: {
      data: {
        accommodation: @accommodation,
        room: @rooms,
        image_urls: @accommodation.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end

  # POST /api/v1/accommodations
  def create
    @accommodation = Accommodation.new(accommodation_params.except(:images))

    authorize @accommodation

    build_images if params[:images].present?
    if @accommodation.save
      accommodation_json
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/accommodations/1
  def update

    authorize @accommodation

    build_images if params[:images].present?
    if @accommodation.update(edit_accommodation_params.except(:images))
      accommodation_json
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/accommodations/1
  def destroy
    authorize @accommodation

    if @accommodation.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  private

  def set_accommodations
    @accommodations = if (params[:geolocations] && params[:check_in] && params[:check_out] && params[:number_of_peoples]).present?
                        # list only published accommodations with free rooms
                        available_accommodations
                      elsif params[:geolocations].present?
                        # list accommodations in definite location
                        policy_scope(Accommodation).geolocation_filter(params[:geolocations])
                      elsif params[:user_id].present?
                        # list accommodations of definite partner
                        policy_scope(Accommodation).where(user_id: params[:user_id])
                      elsif params[:status].present?
                        # list accommodations with definite status
                        policy_scope(Accommodation).where(status: params[:status])
                      else
                        # list all accommodations
                        policy_scope(Accommodation).all
                      end
  end

  def available_accommodations
    available_accommodations = []
    # select published accommodations in definite location
    Accommodation.where(status: 1).geolocation_filter(params[:geolocations]).each do |accommodation|
      # instance variable for Available concern
      @accommodation = accommodation
      # check for selected accommodations with free rooms
      available_accommodations << accommodation if available_rooms.present?
    end
    available_accommodations
  end

  def set_accommodation
    @accommodation = policy_scope(Accommodation).find(params[:id])
  end

  def build_images
    params[:images].each do |img|
      @accommodation.images.attach(io: img, filename: img.original_filename)
    end
  end

  def edit_accommodation
    @accommodation = AccommodationPolicy::EditScope.new(current_user, Accommodation).resolve.find(params[:id])
  end

  def accommodation_params
    params.require(:accommodation).permit(:name, :description, :kind, :phone, :email, :reg_code, :address_owner,
                                          :person, :user_id, images: [])
  end

  # Only allow a list of trusted parameters through.
  def edit_accommodation_params
    params.permit(policy(@accommodation).permitted_attributes)
  end

  def accommodation_json
    render json: {
      data: {
        accommodation: @accommodation,
        image_urls: @accommodation.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end

  def authorize_policy
    authorize Accommodation
  end
end
