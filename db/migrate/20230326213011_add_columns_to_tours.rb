class AddColumnsToTours < ActiveRecord::Migration[7.0]
  def change
    add_reference :tours, :user, null: false, foreign_key: true
    add_column :tours, :reg_code, :string
    add_column :tours, :address_owner, :string
    add_column :tours, :person, :string
    add_column :tours, :description, :text
    add_column :tours, :seats, :integer
    add_column :tours, :price_per_one, :decimal
    add_column :tours, :time_start, :datetime
    add_column :tours, :time_end, :datetime
    add_column :tours, :email, :string
    add_column :tours, :status, :integer, default: 0
  end
end
