class RatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.partner? || user.tourist?
        scope.where(user_id: user.id)
      else
        scope.all
      end
    end
  end

  def show?
    true
  end

  # the same as in show? method
  alias create? show?
  alias update? show?

  def destroy?
    user.admin?
  end
end
