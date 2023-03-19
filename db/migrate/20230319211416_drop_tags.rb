class DropTags < ActiveRecord::Migration[7.0]
  def change
    drop_table :tags do |t|
      t.string :locality
      t.string :tagable_type, null: false
      t.bigint :tagable_id, null: false
      t.timestamps null: false
    end
  end
end
