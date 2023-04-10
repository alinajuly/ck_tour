class AddColumnsToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :full_name, :string
    add_column :reservations, :phone, :string
  end
end
