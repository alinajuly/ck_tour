class ChangeDefaultForBoolean < ActiveRecord::Migration[7.0]
  def change
    change_column :rooms, :breakfast, :boolean, default: nil
    change_column :rooms, :no_smoking, :boolean, default: nil
  end
end
