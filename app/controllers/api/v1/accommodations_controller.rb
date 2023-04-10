class Api::V1::AccommodationsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :authorize_policy
  before_action :set_accommodations, only: :index
  before_action :set_accommodation, only: :show
  before_action :edit_accommodation, only: %i[update destroy]

  # GET /api/v1/accommodations
  def index

    if @accommodations
      render json: { data: @accommodations }, status: :ok
    else
      render json: @accommodations.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1
  def show
    authorize @accommodation

    @rooms = @accommodation.rooms
    render json: { data: @accommodation, rooms: @rooms }, status: :ok
  end

  # POST /api/v1/accommodations
  def create
    @accommodation = Accommodation.new(permitted_attributes(Accommodation))

    authorize @accommodation

    if @accommodation.save
      render json: { data: @accommodation }, status: :created
    else
      render json: @accommodation.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/accommodations/1
  def update
    authorize @accommodation

    if @accommodation.update(accommodation_params)
      render_success(data: @accommodation)
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
    number_of_peoples = params[:number_of_peoples]
    @accommodations = if (params[:geolocations] && params[:check_in] && params[:check_out] && params[:number_of_peoples]).present?
                        policy_scope(Accommodation).joins(:rooms)
                                                   .where('rooms.places >= ?', number_of_peoples)
                                                   .geolocation_filter(params[:geolocations]).distinct
                      elsif params[:geolocations].present?
                        policy_scope(Accommodation).geolocation_filter(params[:geolocations])
                      elsif params[:user_id].present?
                        policy_scope(Accommodation).where(user_id: params[:user_id])
                      elsif params[:status].present?
                        policy_scope(Accommodation).where(status: params[:status])
                      else
                        policy_scope(Accommodation).all
                      end
  end

  def set_accommodation
    @accommodation = policy_scope(Accommodation).find(params[:id])
  end

  def edit_accommodation
    @accommodation = AccommodationPolicy::EditScope.new(current_user, Accommodation).resolve.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def accommodation_params
    params.require(:accommodation).permit(policy(@accommodation).permitted_attributes)
  end

  def authorize_policy
    authorize Accommodation
  end
end
