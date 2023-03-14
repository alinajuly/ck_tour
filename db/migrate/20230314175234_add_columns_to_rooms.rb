class AddColumnsToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :name, :string
    add_column :rooms, :quantity, :integer
  end
end
