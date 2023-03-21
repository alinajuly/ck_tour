class AddNewColumnsToAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_reference :accommodations, :user, null: false, foreign_key: true
    add_column :accommodations, :reg_code, :string
    add_column :accommodations, :address_owner, :string
    add_column :accommodations, :person, :string
  end
end
