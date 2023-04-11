class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        # admin can see all bookings
        scope.all
      elsif user.partner?
        # partner can see bookings of his own accommodations or his own bookings
        scope.joins(room: :accommodation).where(accommodations: { id: user.accommodations.ids }).or(scope.where(user_id: user.id))
      else
        # tourist can see his own bookings only
        scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.partner?
      # partner can confirm tourist's bookings and edit other params
      %i[confirmation number_of_peoples check_in check_out note phone full_name room_id]
    elsif user.tourist?
      # tourist can edit his own booking params, but not confirm
      %i[number_of_peoples check_in check_out note phone full_name room_id]
    end
  end

  def index?
    true
  end

  def show?
    # admin can view all bookings, non-admin users - his own bookings or bookings of his own accommodations
    user.admin? || record.user_id == user.id || record.room.accommodation.user_id == user.id
  end

  # the same as in show? method
  alias update? show?
  alias destroy? show?

  def create?
    # tourist and partner can book an accommodation
    user.tourist? || user.partner?
  end

  def list_for_partner?
    # only partner can view bookings
    user.partner?
  end
end
