class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :places
      t.string :bad
      t.decimal :price_per_night
      t.text :description
      t.boolean :breakfast
      t.boolean :no_smoking
      t.references :accommodation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
