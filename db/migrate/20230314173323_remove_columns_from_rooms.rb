class RemoveColumnsFromRooms < ActiveRecord::Migration[7.0]
  def change
    remove_column :rooms, :breakfast, :boolean
    remove_column :rooms, :conditioner, :boolean
  end
end
