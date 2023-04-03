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

  def permitted_attributes
    if user.admin?
      [:status]
    elsif user.partner?
      %i[title description address_owner reg_code person seats price_per_one time_start time_end phone email user_id]
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

  def index_unpublished?
    user.partner? || user.admin?
  end

  def show_unpublished?
    user.partner? || user.admin?
  end
end
