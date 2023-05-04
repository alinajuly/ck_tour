class RatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        user.present?
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    true
  end

  # the same as in show? method
  alias show? index?
  alias create? index?
  alias update? index?

  def destroy?
    user.admin?
  end
end
