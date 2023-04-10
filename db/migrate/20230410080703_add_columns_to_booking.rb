class AddColumnsToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :full_name, :string
    add_column :bookings, :phone, :string
  end
end
