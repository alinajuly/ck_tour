class CreateFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :facilities do |t|
      t.date :checkin_start
      t.date :checkin_end
      t.date :checkout_start
      t.date :checkout_end

      t.timestamps
    end
  end
end
