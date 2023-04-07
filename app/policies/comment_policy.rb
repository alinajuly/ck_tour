class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present? && user.admin?
        scope.all
      elsif user.present? && (user.partner? || user.tourist?)
        scope.where(status: 1).or(scope.where(user_id: user.id))
      else
        scope.where(status: 1)
      end
    end
  end

  class EditScope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
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
    true
  end

  def update?
    user.admin?
  end

  def destroy?
    true
  end
end
