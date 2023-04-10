class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.partner?
        scope.joins(room: :accommodation).where(accommodations: { id: user.accommodations.ids })
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def permitted_attributes
    if user.partner?
      %i[confirmation number_of_peoples check_in check_out note phone full_name room_id]
    elsif user.tourist?
      %i[number_of_peoples check_in check_out note phone full_name room_id]
    end
  end

  def index?
    true
  end

  def show?
    # debugger
    # true
    user.admin? || record.user == user #|| record.room.accommodation.user_id == user.id
  end

  def create?
    user.tourist? || user.partner?
  end

  def update?
    true
    # user.admin? || user_id == user.id
    # (user.tourist? && booking.user_id == user.id) || user.partner? if booking.room.accommodation.user == user
    # (user.tourist? || user.partner?) && record.user_id == user.id
  end

  def destroy?
    true
  end

  def list_for_partner?
    user.partner?
  end
end
