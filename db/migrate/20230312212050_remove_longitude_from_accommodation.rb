class RemoveLongitudeFromAccommodation < ActiveRecord::Migration[7.0]
  def change
    remove_column :accommodations, :longitude, :decimal
  end
end
