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
    true
  end

  def destroy?
    true
  end

  def confirm?
    user.partner?
  end

  def cancel?
    user.partner?
  end
end
