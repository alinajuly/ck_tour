class Api::V1::PartnersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_partner, only: [:show, :destroy]

  # GET api/v1/partners
  def index
    @partners = Partner.all
    render json: @partners, status: :ok
  end

  # GET api/v1/partners/{name}
  def show
    render json: @partner, status: :ok
  end

  # POST api/v1/partners
  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      render json: @partner, status: :created
    else
      render json: { errors: @partner.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT api/v1/partners/{name}
  def update
    if partner&.authenticate(params[:current_password])
      partner.update(password: params[:new_password])
      render json: { message: 'Password updated successfully' }, status: :ok
    else
      render json: { error: 'Invalid current password' }, status: :unprocessable_entity
    end
    # unless @partner.update(partner_params)
    #   render json: { errors: @partner.errors.full_messages },
    #          status: :unprocessable_entity
    # end
  end

  # DELETE api/v1/partners/{name}
  def destroy
    @partner.destroy
  end

  private

  def partner_params
    params.permit(:name, :email, :password)
  end

  def set_partner
    @partner = Partner.find(params[:id])
  end
end
