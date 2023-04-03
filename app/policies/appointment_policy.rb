class AppointmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner?
        scope.joins(tour:).where(tour: { user_id: user.id })
        # scope.where(tour.user_id == user.id)
        # scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.partner?
      [:confirmation]
    elsif user.tourist || user.partner?
      %i[number_of_peoples tour_id]
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.tourist? || user.partner?
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def list_for_partner?
    user.partner?
  end
end
