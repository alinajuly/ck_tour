class CateringPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present? && user.admin?
        scope.all
      elsif user.present? && user.partner?
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
      elsif user.partner?
        scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.admin?
      [:status]
    elsif user.partner?
      [:places, :description, :name, :kind, :phone, :email, :reg_code, :address_owner, :person, :user_id,
       { images: [] }]
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
end
