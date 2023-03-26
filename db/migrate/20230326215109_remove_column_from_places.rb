class RemoveColumnFromPlaces < ActiveRecord::Migration[7.0]
  def change
    remove_column :places, :title, :string
    remove_column :places, :latitude, :decimal
    remove_column :places, :longitude, :decimal
  end
end
