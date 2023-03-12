class RemoveLatitudeFromAccommodation < ActiveRecord::Migration[7.0]
  def change
    remove_column :accommodations, :latitude, :decimal
  end
end
