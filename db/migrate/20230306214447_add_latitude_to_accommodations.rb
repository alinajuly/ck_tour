class AddLatitudeToAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :accommodations, :latitude, :decimal, precision: 10, scale: 6
  end
end
