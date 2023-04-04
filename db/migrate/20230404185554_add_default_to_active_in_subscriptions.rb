class AddDefaultToActiveInSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_column_default :subscriptions, :active, true
  end
end
