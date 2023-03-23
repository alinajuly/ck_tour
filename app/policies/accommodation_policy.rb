class AccommodationPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     if user.admin?
  #       scope.all
  #     else
  #       scope.published
  #     end
  #   end
  # end
  
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.partner?
  end

  def update?
    user.partner? || user.admin?
  end

  def destroy?
    user.partner? || user.admin?
  end

  def change_status?
    user.admin? # Only an admin can confirm a partner's create accommodations
  end
end
