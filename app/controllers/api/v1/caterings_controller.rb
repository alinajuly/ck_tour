class Api::V1::CateringsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_catering, only: %i[update destroy]
  before_action :set_for_publish, only: %i[publish unpublish]
  before_action :authorize_policy

  # GET /api/v1/accommodations/1/caterings
  def index
    @check_in = params[:check_in]
    @check_out = params[:check_out]
    @number_of_peoples = params[:number_of_peoples]

    @caterings = if @check_in.present? && @check_out.present? && @number_of_peoples.present?
                   available_caterings
                 else
                   Catering.all
                 end

    authorize @caterings

    if @caterings
      render json: { data: @caterings }, status: :ok
    else
      render json: @caterings.errors, status: :bad_request
    end
  end

  def index_unpublished
    @caterings = policy_scope(Catering).all.unpublished

    authorize @caterings

    if @caterings
      render json: { data: @caterings }, status: :ok
    else
      render json: @caterings.errors, status: :bad_request
    end
  end

  # GET /api/v1/accommodations/1/caterings/1
  def show
    @catering = Catering.find(params[:id]) if Catering.find(params[:id]).published?
    authorize @catering

    render json: @catering, status: :ok
  end

  def show_unpublished
    @catering = policy_scope(Catering).find(params[:catering_id])
    authorize @catering

    if @catering
      render json: { data: @catering }, status: :ok
    else
      render json: @catering.errors, status: :bad_request
    end
  end

  # POST /api/v1/caterings
  def create
    @catering = Catering.new(catering_params)

    authorize @catering

    if @catering.save
      render json: { data: @catering }, status: :created
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/caterings/1
  def update
    authorize @catering

    if @catering.update(catering_params.except(:status))
      render json: { status: 'Update', data: @catering }, status: :ok
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  def publish
    authorize @catering

    if @catering.published!
      render json: { status: 'Item is published', data: @catering }, status: :ok
    else
      render json: @catering.errors, status: :unprocessable_entity
    end
  end

  def unpublish
    authorize @catering

    if @catering.unpublished!
      render json: { status: 'Item is hidden', data: @catering }, status: :ok
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
    @catering = Catering.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'catering id not found' }, status: :not_found
  end

  def set_for_publish
    @catering = Catering.find(params[:catering_id])
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    render json: { message: 'catering id not found' }, status: :not_found
  end

  def reserved_catering_ids(check_in, check_out)
    Reservation.joins(:catering).where(check_in: ..check_out, check_out: check_in..).pluck(:catering_id)
  end

  def available_caterings
    @free_places = @caterings.where.not(id: reserved_catering_ids(@check_in, @check_out)).pluck(:places).sum
    return unless @free_places >= @number_of_peoples.to_i

    @available_caterings = @caterings.where.not(id: reserved_catering_ids(@check_in, @check_out))
  end

  # Only allow a list of trusted parameters through.
  def catering_params
    params.permit(:places, :description, :name, :kind, :phone, :email, :reg_code, :address_owner, :person,
                  reservations_attributes: %i[id check_in check_out number_of_peoples])
  end

  def authorize_policy
    authorize Catering
  end
end
