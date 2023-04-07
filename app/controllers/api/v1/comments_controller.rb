module Api
  module V1
    class CommentsController < ApplicationController
      include ResourceFinder
      before_action :set_comment, only: %i[update destroy]
      before_action :set_user
      skip_before_action :authenticate_request, only: %i[index show]
      before_action :authorize_policy


      # GET /api/v1/comments
      def index
        @comments = parentable.policy_scope(Comment)

        authorize @comments

        render json: @comments
      end

      # GET /api/v1/comments/1
      def show
        @comment = parentable.policy_scope(Comment)
        authorize @comment

        render json: @comment
      end

      # POST /api/v1/comments
      def create
        @comment = parentable.policy_scope(permitted_attributes(Comment))

        authorize @comment

        if @comment.save
          render json: @comment, status: :created, location: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/comments/1
      def update
        authorize @comment

        if @comment.update(comment_params)
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
        @comment = parentable.CommentPolicy::EditScope.new(current_user, Comment).resolve
      end

      def set_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        logger.info e
        render json: { message: 'user id not found' }, status: :not_found
      end

      # Only allow a list of trusted parameters through.
      def comment_params
        params.permit(:body, :user_id)
      end

      def authorize_policy
        authorize Comment
      end
    end
  end
end
