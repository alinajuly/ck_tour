class GeolocationPolicy < ApplicationPolicy
  def index?
    true
  end

  alias show? index?
  alias geolocations_map? index?

  def create?
    user.partner? || user.admin?
  end

  def update?
    user.partner? || user.admin?
  end

  def destroy?
    user.partner? || user.admin?
  end
end
