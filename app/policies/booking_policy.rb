class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner?
        # scope.joins(accommodation: :room).where(user_id: user.id)
        scope.joins(room: :accommodation).where(accommodations: { user_id: user.id })
      end
    end
  end

  def permitted_attributes
    if user.partner?
      [:confirmation]
    elsif user.tourist? || user.partner?
      %i[number_of_peoples check_in check_out note room_id]
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
