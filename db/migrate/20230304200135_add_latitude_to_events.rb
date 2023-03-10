class AddLatitudeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :latitude, :decimal, precision: 10, scale: 6
  end
end
