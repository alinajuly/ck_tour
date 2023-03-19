class CreateToponyms < ActiveRecord::Migration[7.0]
  def change
    create_table :toponyms do |t|
      t.string :locality
      t.references :toponymable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
