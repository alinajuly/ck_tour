class ToponymPolicy < ApplicationPolicy
  def index?
    true
  end
  
  def show?
    true
  end

  def create?
    user.partner? && user.admin?
  end

  def update?
    user.partner? && user.admin?
  end

  def destroy?
    user.partner? && user.admin?
  end
end
