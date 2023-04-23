class Api::V1::CateringsController < ApplicationController
  include Rails.application.routes.url_helpers

  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :set_catering, only: :show
  before_action :edit_catering, only: %i[update destroy]
  before_action :authorize_policy

  # GET /api/v1/accommodations/1/caterings
  def index
    # methods

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

  # GET /api/v1/accommodations/1/caterings/1
  def show
    authorize @catering

    render json: {
      data: {
        catering: @catering,
        image_urls: @catering.images.map { |image| url_for(image) }
      }
    }, status: :ok
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

  def build_images
    params[:images].each do |img|
      @catering.images.attach(io: img, filename: img.original_filename)
    end
  end

  def reserved_catering_ids(check_in, check_out)
    Reservation.joins(:catering).where(check_in: ..check_out, check_out: check_in..).pluck(:catering_id)
  end

  def available_caterings
    check_in = params[:check_in].to_time
    check_out = params[:check_out].to_time
    # select reserved caterings with number of reserved places
    time_ranges = Reservation.upcoming_reservation.map { |r| [r.catering_id, r.number_of_peoples, r.check_in...r.check_out] }
    # select reserved caterings ids (with number of reserved places) overlaping with new reservation time range in query
    reservation_time_ranges = time_ranges.select { |array| array[2].overlaps?(check_in...check_out) }
    # select overlaping reserved caterings ids with number of reserved places
    reserved_places = reservation_time_ranges.map { |array| [array[0], array[1]] }
    # group reservations by catering_id and sum the number_of_peoples for each group
    reserved_places_summed = reserved_places.group_by(&:first).map { |id, arr| [id, arr.map(&:last).sum] }
    # filter out the catering_ids where with no available places
    full_reserved_catering_ids = reserved_places_summed.select { |id, sum| sum >= Catering.find(id).places }.map(&:first)
    # filter out the caterings are available for reservation
    Catering.where.not(id: full_reserved_catering_ids).published
  end

  def catering_params
    params.permit(:places, :description, :name, :kind, :phone, :email, :reg_code, :address_owner, :person,
                  :user_id, images: [])
  end

  def edit_catering_params
    params.permit(policy(@catering).permitted_attributes)
  end

  def catering_json
    render json: {
      data: {
        catering: @catering,
        image_urls: @catering.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end

  def authorize_policy
    authorize Catering
  end
end
