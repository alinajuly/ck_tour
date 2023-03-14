class ChangeFormatForFacilities < ActiveRecord::Migration[7.0]
  def change
    change_column :facilities, :checkin_start, :datetime
    change_column :facilities, :checkin_end, :datetime
    change_column :facilities, :checkout_start, :datetime
    change_column :facilities, :checkout_end, :datetime
  end
end
