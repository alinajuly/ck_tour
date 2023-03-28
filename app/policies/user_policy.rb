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
    # @user.admin? || @user.id == @current_user.id || @user.partner? || @user.tourist?
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

  def change_role?
    true
  end

  def create_admin?
    user.admin?
  end
end
