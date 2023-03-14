class AddColumnsToFacilities < ActiveRecord::Migration[7.0]
  def change
    add_reference :facilities, :accommodation, null: false, foreign_key: true
    add_column :facilities, :credit_card, :boolean, default: false
    add_column :facilities, :free_parking, :boolean, default: false
    add_column :facilities, :wi_fi, :boolean, default: false
    add_column :facilities, :breakfast, :boolean, default: false
    add_column :facilities, :pets, :boolean, default: false
  end
end
