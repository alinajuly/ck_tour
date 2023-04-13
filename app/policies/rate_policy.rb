class RatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def show?
    true
  end

  # the same as in show? method
  alias create? show?
  alias update? show?
  alias destroy? show?
end
