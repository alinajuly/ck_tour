class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present? && user.admin?
        scope.all
      else
        scope.where(status: 1)
      end
    end
  end

  class DeleteScope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    # user.admin? || (record.status.eql? 1)
    true
  end

  def show?
    user.admin? || (record.status.eql? 1)
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
