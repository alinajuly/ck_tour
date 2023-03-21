class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner?
        scope.where(id: user.id)
      elsif user.tourist?
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
    # user.admin? || user.id == record.id || user.partner? || user.tourist?
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def create_admin?
    user.admin?
  end

  def change_role?
    true
  end
end
