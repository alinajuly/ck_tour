class Api::V1::CommentsController < ApplicationController
  include ResourceFinder
  before_action :current_user, only: %i[index show]
  before_action :set_comment, only: %i[update destroy]
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :authorize_policy

  # GET /api/v1/comments
  def index
    @comments = policy_scope(parentable.comments)

    render json: CommentSerializer.new(@comments)
  end

  # GET /api/v1/comments/1
  def show
    @comment = policy_scope(parentable.comments).find(params[:id])

    render json: CommentSerializer.new(@comment)
  end

  # POST /api/v1/comments
  def create
    @comment = parentable.comments.new(comment_params)

    authorize @comment

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/comments/1
  def update
    authorize @comment

    if @comment.update(comment_status_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/1
  def destroy
    if @comment.destroy!
      render json: { status: 'Delete' }, status: :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = policy_scope(parentable.comments, policy_scope_class: CommentPolicy::DeleteScope).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.permit(:body, :user_id, :commentable_id, :commentable_type).merge(user_id: current_user.id)
  end

  def comment_status_params
    params.permit(:status)
  end

  def authorize_policy
    authorize Comment
  end
end
