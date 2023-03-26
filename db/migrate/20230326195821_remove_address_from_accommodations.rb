class RemoveAddressFromAccommodations < ActiveRecord::Migration[7.0]
  def change
    remove_column :accommodations, :address, :string
  end
end
