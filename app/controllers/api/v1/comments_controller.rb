module Api
  module V1
    class CommentsController < ApplicationController
      include ResourceFinder
      before_action :current_user, only: %i[index show]
      before_action :set_comment, only: %i[update destroy]
      skip_before_action :authenticate_request, only: %i[index show]
      before_action :authorize_policy

      # GET /api/v1/comments
      def index
        # @comments = parentable.comments
        @comments = policy_scope(parentable.comments)

        render json: @comments
      end

      # GET /api/v1/comments/1
      def show
        @comment = parentable.comments
        # @comment = policy_scope(parentable.comments)
        authorize @comment

        render json: @comment
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

        if @comment.update(params[:status])
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/comments/1
      def destroy
        authorize @comment

        if @comment.destroy!
          render json: { status: 'Delete' }, status: :no_content
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = parentable.comments
        # @comment = CommentPolicy::EditScope.new(current_user, parentable.comments).resolve
      end

      # Only allow a list of trusted parameters through.
      def comment_params
        params.require(:comment).permit(:body, :user_id).merge(user_id: current_user.id)
      end

      def authorize_policy
        authorize Comment
      end
    end
  end
end
