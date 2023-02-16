class Api::V1::EventsController < ApplicationController
  before_action :set_api_v1_event, only: %i[ show update destroy ]

  # GET /api/v1/events
  def index
    @api_v1_events = Api::V1::Event.all

    render json: @api_v1_events
  end

  # GET /api/v1/events/1
  def show
    render json: @api_v1_event
  end

  # POST /api/v1/events
  def create
    @api_v1_event = Api::V1::Event.new(api_v1_event_params)

    if @api_v1_event.save
      render json: @api_v1_event, status: :created, location: @api_v1_event
    else
      render json: @api_v1_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/events/1
  def update
    if @api_v1_event.update(api_v1_event_params)
      render json: @api_v1_event
    else
      render json: @api_v1_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/events/1
  def destroy
    @api_v1_event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_event
      @api_v1_event = Api::V1::Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_event_params
      params.fetch(:api_v1_event, {})
    end
end
