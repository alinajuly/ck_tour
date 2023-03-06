class AddLongitudeToAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :accommodations, :longitude, :decimal, precision: 10, scale: 6
  end
end
