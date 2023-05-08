module Tourable
  extend ActiveSupport::Concern

  def not_in_past
    errors.add(:time_start, "can't be in the past") if time_start < Time.current
  end
end
