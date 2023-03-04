class AddLongitudeToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :longitude, :decimal, precision: 10, scale: 6
  end
end
