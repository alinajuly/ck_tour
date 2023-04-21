class ReservationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        # admin can see all reservations
        scope.all
      elsif user.partner?
        # partner can see reservations of his own caterings or his own reservations
        scope.joins(:catering).where(caterings: { id: user.caterings.ids }).or(scope.where(user_id: user.id))
      else
        # tourist can see his own reservations only
        scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.partner?
      # partner can confirm tourist's reservations and edit other params
      %i[confirmation number_of_peoples check_in check_out note phone full_name catering_id]
    elsif user.tourist?
      # tourist can edit his own reservation params, but not confirm
      %i[number_of_peoples check_in check_out note phone full_name catering_id]
    end
  end

  def index?
    true
  end

  def show?
    # admin can view all reservations, non-admin users - his own reservations or reservations of his own caterings
    user.admin? || record.user_id == user.id || record.catering.user_id == user.id
  end

  # the same as in show? method
  alias update? show?
  alias destroy? show?

  def create?
    # tourist and partner can reserve a catering
    user.tourist? || user.partner?
  end

  def list_for_partner?
    # only partner can view reservations
    user.partner?
  end
end
