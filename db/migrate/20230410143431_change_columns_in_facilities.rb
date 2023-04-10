class ChangeColumnsInFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :facilities, :data, :jsonb
    remove_column :facilities, :credit_card, :boolean, default: false
    remove_column :facilities, :free_parking, :boolean, default: false
    remove_column :facilities, :wi_fi, :boolean, default: false
    remove_column :facilities, :breakfast, :boolean, default: false
    remove_column :facilities, :pets, :boolean, default: false
    remove_column :facilities, :checkin_start, :datetime
    remove_column :facilities, :checkin_end, :datetime
    remove_column :facilities, :checkout_start, :datetime
    remove_column :facilities, :checkout_end, :datetime
  end
end
