class RenameBadToBed < ActiveRecord::Migration[7.0]
  def change
    rename_column :rooms, :bad, :bed
  end
end
