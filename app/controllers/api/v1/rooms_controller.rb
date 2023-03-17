module Api
  module V1
    class RoomsController < ApplicationController
      before_action :set_accommodation
      before_action :set_room, only: %i[show update destroy]

      # GET /api/v1/accommodations/1/rooms
      def index
        @check_in = params[:check_in]
        @check_out = params[:check_out]
        @number_of_peoples = params[:number_of_peoples]

        @rooms = if @check_in.present? && @check_out.present? && @number_of_peoples.present?
                   available_rooms
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
        @room = @accommodation.rooms.new(room_params)
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

      def booked_room_ids(check_in, check_out)
        Booking.joins(:room)
               .where(check_in: ..check_out, check_out: check_in..)
               .pluck(:room_id)
      end

      def available_rooms
        @accommodation.rooms.where('places >= ?', @number_of_peoples)
                      .where.not(id: booked_room_ids(@check_in, @check_out))
      end

      # Only allow a list of trusted parameters through.
      def room_params
        params.permit(:places, :bed, :name, :quantity, :description, :price_per_night, bookings_attributes: [:id, :check_in, :check_out, :number_of_peoples])
      end
    end
  end
end
