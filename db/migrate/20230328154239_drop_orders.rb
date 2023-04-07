class DropOrders < ActiveRecord::Migration[7.0]
  def change
    drop_table :orders do |t|
      t.integer :number_of_peoples
      t.references :user, null: false, foreign_key: true
      t.references :tour, null: false, foreign_key: true
      t.integer :confirmation, default: 0
      t.timestamps
    end
  end
end
