class BookingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.tourist?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
