class ChangeColumnsForBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :is_active, :boolean
    add_column :bookings, :note, :text
    add_column :bookings, :confirmation, :integer, default: 0
  end
end
