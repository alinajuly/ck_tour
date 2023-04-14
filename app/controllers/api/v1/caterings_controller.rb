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
    @check_in = params[:check_in]
    @check_out = params[:check_out]
    @number_of_peoples = params[:number_of_peoples]

    @caterings = if (@check_in && @check_out && @number_of_peoples).present?
                   available_caterings
                 elsif params[:user_id].present?
                   policy_scope(Catering).where(user_id: params[:user_id])
                 elsif params[:status].present?
                   policy_scope(Catering).where(status: params[:status])
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
    @free_places = @caterings.published.where.not(id: reserved_catering_ids(@check_in, @check_out)).pluck(:places).sum
    return if @number_of_peoples.nil?
    return unless @free_places >= @number_of_peoples.to_i

    @available_caterings = @caterings.where.not(id: reserved_catering_ids(@check_in, @check_out)).published
  end

  def catering_params
    params.require(:catering).permit(:places, :description, :name, :kind, :phone, :email, :reg_code, :address_owner,
                                     :person, :user_id, images: [])
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
