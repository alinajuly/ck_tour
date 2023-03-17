module Api
  module V1
    class RoomsController < ApplicationController
      before_action :set_accommodation
      before_action :set_room, only: %i[show update destroy]

      # GET /api/v1/accommodations/1/rooms
      def index
        @rooms = if booking_params_present?
                   @accommodation.rooms.where('places >= ?', params[:number_of_people])
                                 .where('quantity > 0')
                                 .where.not(id: booked_room_ids(params[:check_in], params[:check_out]))
                 else
                   @accommodation.rooms.all
                 end

        if @rooms
          render json: { data: @rooms }, status: :ok
        else
          render json: @rooms.errors, status: :bad_request
        end
      end

      # GET /api/v1/accommodations/1/rooms/1
      def show
        render json: @room, status: :ok
      end

      # POST /api/v1/rooms
      def create
        @room = Room.new(room_params)
        if @room.save
          render json: { data: @room }, status: :created
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/rooms/1
      def update
        if @room.update(room_params)
          render json: { status: 'Update', data: @room }, status: :ok
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/rooms/1
      def destroy
        if @room.destroy!
          render json: { status: 'Delete' }, status: :ok
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end

      private

      def set_accommodation
        @accommodation = Accommodation.find_by_id(params[:accommodation_id])
      rescue ActiveRecord::RecordNotFound => e
        logger.info e
        render json: { message: 'accommodation id not found' }, status: :not_found
      end

      def set_room
        @room = Room.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        logger.info e
        render json: { message: 'room id not found' }, status: :not_found
      end

      def booking_params
        params.permit(bookings_attributes: [:check_in, :check_out, :number_of_people])
      end

      def booking_params_present?
        booking_params[:check_in].present? && booking_params[:check_out].present? && booking_params[:number_of_people].present?
      end

      def booked_room_ids(check_in, check_out)
        Booking.joins(:room)
                .where('check_out > ? AND check_in < ?', check_in, check_out)
                .pluck(:room_id)
      end

      # Only allow a list of trusted parameters through.
      def room_params
        params.permit(:places, :bed, :name, :quantity, :description, :price_per_night)
      end
    end
  end
end
