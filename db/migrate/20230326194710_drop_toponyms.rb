class DropToponyms < ActiveRecord::Migration[7.0]
  def change
    drop_table :toponyms do |t|
      t.string :locality
      t.string :toponymable_type, null: false
      t.bigint :toponymable_id, null: false
      t.timestamps null: false
    end
  end
end
