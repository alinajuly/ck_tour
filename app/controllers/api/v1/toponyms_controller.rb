module Api
  module V1
    class ToponymsController < ApplicationController
      skip_before_action :authenticate_request, only: %i[show index]
      before_action :set_toponym, only: %i[show update destroy]

      # GET /api/v1/toponyms
      def index
        @toponyms = Toponym.all

        render json: @toponyms
      end

      # GET /api/v1/toponyms/1
      def show
        render json: @toponym
      end

      # POST /api/v1/toponyms
      def create
        @toponym = Toponym.new(toponym_params)

        if @toponym.save
          render json: @toponym, status: :created, location: @toponym
        else
          render json: @toponym.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/toponyms/1
      def update
        if @toponym.update(toponym_params)
          render json: @toponym
        else
          render json: @toponym.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/toponyms/1
      def destroy
        @toponym.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_toponym
        @toponym = Toponym.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def toponym_params
        params.require(:toponym).permit(:locality)
      end
    end
  end
end
