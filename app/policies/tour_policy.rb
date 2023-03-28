class TourPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner?
        scope.where(user_id: user.id)
      else
        scope.where(status: published)
      end
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.partner?
  end

  def update?
    user.partner? || user.admin?
  end

  def destroy?
    user.partner? || user.admin?
  end

  def publish?
    user.admin? # Only an admin can confirm a partner's create accommodations
  end

  def unpublish?
    user.admin? # Only an admin can confirm a partner's create accommodations
  end

  def index_unpublished?
    user.partner? || user.admin?
  end

  def show_unpublished?
    user.partner? || user.admin?
  end
end
