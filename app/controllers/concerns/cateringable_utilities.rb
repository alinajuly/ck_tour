module CateringableUtilities
  extend ActiveSupport::Concern
  
  def build_images
    params[:images].each do |img|
      @catering.images.attach(io: img, filename: img.original_filename)
    end
  end

  def reserved_catering_ids(check_in, check_out)
    Reservation.joins(:catering).where(check_in: ..check_out, check_out: check_in..).pluck(:catering_id)
  end

  def available_caterings
    check_in = params[:check_in].to_time
    check_out = params[:check_out].to_time
    # select reserved caterings with number of reserved places
    time_ranges = Reservation.upcoming_reservation.map { |r| [r.catering_id, r.number_of_peoples, r.check_in...r.check_out] }
    # select reserved caterings ids (with number of reserved places) overlaping with new reservation time range in query
    reservation_time_ranges = time_ranges.select { |array| array[2].overlaps?(check_in...check_out) }
    # select overlaping reserved caterings ids with number of reserved places
    reserved_places = reservation_time_ranges.map { |array| [array[0], array[1]] }
    # group reservations by catering_id and sum the number_of_peoples for each group
    reserved_places_summed = reserved_places.group_by(&:first).map { |id, arr| [id, arr.map(&:last).sum] }
    # filter out the catering_ids where with no available places
    full_reserved_catering_ids = reserved_places_summed.select { |id, sum| sum >= Catering.find(id).places }.map(&:first)
    # filter out the caterings are available for reservation
    Catering.where.not(id: full_reserved_catering_ids).published
  end

  def edit_catering_params
    params.permit(policy(@catering).permitted_attributes)
  end

  def catering_json
    render json: {
      data: {
        catering: CateringSerializer.new(@catering),
        image_urls: @catering.images.map { |image| url_for(image) }
      }
    }, status: :ok
  end
end
