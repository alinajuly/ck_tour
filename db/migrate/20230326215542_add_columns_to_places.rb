class AddColumnsToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_reference :places, :tour, null: false, foreign_key: true
    add_column :places, :name, :string
  end
end
