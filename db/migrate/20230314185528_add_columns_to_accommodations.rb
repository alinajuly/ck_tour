class AddColumnsToAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :accommodations, :phone, :string
  end
end
