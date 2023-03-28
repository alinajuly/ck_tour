class AppointmentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.tourist? || user.partner?
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
