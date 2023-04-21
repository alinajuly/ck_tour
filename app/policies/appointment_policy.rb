class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        # admin can see all bookings
        scope.all
      elsif user.partner?
        # partner can see bookings of his own tours or his own bookings
        scope.joins(:tour).where(tours: { id: user.tours.ids }).or(scope.where(user_id: user.id))
      else
        # tourist can see his own bookings only
        scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.partner?
      # partner can confirm tourist's bookings and edit other params
      %i[confirmation number_of_peoples note phone full_name tour_id]
    elsif user.tourist?
      # tourist can edit his own booking params, but not confirm
      %i[number_of_peoples note phone full_name tour_id]
    end
  end

  def index?
    true
  end

  def show?
    # admin can view all bookings, non-admin users - his own bookings or bookings of his own accommodations
    user.admin? || record.user_id == user.id || record.tour.user_id == user.id
  end

  # the same as in show? method
  alias update? show?
  alias destroy? show?

  def create?
    # tourist and partner can book a tour
    user.tourist? || user.partner?
  end

  def list_for_partner?
    # only partner can view bookings
    user.partner?
  end
end
