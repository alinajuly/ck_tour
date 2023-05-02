class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner? || user.tourist?
        scope.where(id: user.id)
      else
        scope.none
      end
    end
  end

  def index?
    user.admin?
  end

  def show?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def create_admin?
    user.admin?
  end

  def unpublished_comments?
    user.admin?
  end
end
