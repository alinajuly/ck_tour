class AddIntervalCountToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :interval_count, :integer, default: 1, null: false
  end
end
