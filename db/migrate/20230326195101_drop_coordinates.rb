class DropCoordinates < ActiveRecord::Migration[7.0]
  def change
    drop_table :coordinates do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :toponymable_type, null: false
      t.bigint :toponymable_id, null: false
      t.timestamps null: false
    end
  end
end
