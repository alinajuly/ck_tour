class Api::V1::CateringsController < ApplicationController
  include Rails.application.routes.url_helpers
  include CateringableUtilities

  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :set_catering, only: :show
  before_action :edit_catering, only: %i[update destroy]
  before_action :authorize_policy

  # GET /api/v1/caterings
  def index
    @caterings = if (params[:check_in] && params[:check_out]).present?
                   available_caterings
                 elsif params[:geolocations].present?
                   policy_scope(Catering).geolocation_filter(params[:geolocations])
                 elsif params[:user_id].present?
                   policy_scope(Catering).filter_by_partner(params[:user_id])
                 elsif params[:status].present?
                   policy_scope(Catering).filter_by_status(params[:status])
                 else
                   policy_scope(Catering).all
                 end

    authorize @caterings

    if @caterings
      render json: { data: @caterings.map { |catering| catering.as_json.merge(images: catering.images.map { |image| url_for(image) }) } }, status: :ok
    else
      render json: @caterings.errors, status: :bad_request
    end
  end

  # GET /api/v1/caterings/1
  def show
    authorize @catering

    catering_json
  end

  # POST /api/v1/caterings
  def create
    @catering = Catering.new(catering_params.except(:images))

    authorize @catering

    build_images if params[:images].present?
    if @catering.save
      catering_json
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/caterings/1
  def update
    authorize @catering

    build_images if params[:images].present?
    if @catering.update(edit_catering_params.except(:images))
      if @catering.published? && params[:status].present?
        StatusMailer.catering_published(@catering.user, @catering).deliver_later
      end
      catering_json
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/caterings/1
  def destroy
    authorize @catering

    if @catering.destroy!
      render json: { status: 'Delete' }, status: :ok
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  private

  def set_catering
    @catering = policy_scope(Catering).find(params[:id])
  end

  def edit_catering
    @catering = CateringPolicy::EditScope.new(current_user, Catering).resolve.find(params[:id])
  end

  def catering_params
    params.permit(:places, :description, :name, :kind, :phone, :email, :reg_code, :address_owner, :person,
                  :user_id, images: [])
  end

  def authorize_policy
    authorize Catering
  end
end
