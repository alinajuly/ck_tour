class Api::V1::TagsController < ApplicationController
  before_action :set_api_v1_tag, only: %i[ show update destroy ]

  # GET /api/v1/tags
  def index
    @api_v1_tags = Api::V1::Tag.all

    render json: @api_v1_tags
  end

  # GET /api/v1/tags/1
  def show
    render json: @api_v1_tag
  end

  # POST /api/v1/tags
  def create
    @api_v1_tag = Api::V1::Tag.new(api_v1_tag_params)

    if @api_v1_tag.save
      render json: @api_v1_tag, status: :created, location: @api_v1_tag
    else
      render json: @api_v1_tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/tags/1
  def update
    if @api_v1_tag.update(api_v1_tag_params)
      render json: @api_v1_tag
    else
      render json: @api_v1_tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tags/1
  def destroy
    @api_v1_tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_tag
      @api_v1_tag = Api::V1::Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_tag_params
      params.fetch(:api_v1_tag, {})
    end
end
