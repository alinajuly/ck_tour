class AddTrialPeriodDaysToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :trial_period_days, :integer, default: 30
  end
end
