class ReservationPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     if user.admin?
  #       scope.all
  #     elsif user.partner?
  #       scope.joins(catering:).where(catering: { user_id: user.id })
  #     end
  #   end
  # end

  def permitted_attributes
    if user.partner?
      [:confirmation]
    elsif user.tourist? || user.partner?
      %i[number_of_peoples check_in check_out note catering_id]
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
