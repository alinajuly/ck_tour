class Api::V1::CommentsController < ApplicationController
  before_action :set_api_v1_comment, only: %i[show update destroy]

  # GET /api/v1/comments
  def index
    @api_v1_comments = Api::V1::Comment.all

    render json: @api_v1_comments
  end

  # GET /api/v1/comments/1
  def show
    render json: @api_v1_comment
  end

  # POST /api/v1/comments
  def create
    @api_v1_comment = Api::V1::Comment.new(api_v1_comment_params)

    if @api_v1_comment.save
      render json: @api_v1_comment, status: :created, location: @api_v1_comment
    else
      render json: @api_v1_comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/comments/1
  def update
    if @api_v1_comment.update(api_v1_comment_params)
      render json: @api_v1_comment
    else
      render json: @api_v1_comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/1
  def destroy
    @api_v1_comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_comment
      @api_v1_comment = Api::V1::Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_comment_params
      params.fetch(:api_v1_comment, {})
    end
end
