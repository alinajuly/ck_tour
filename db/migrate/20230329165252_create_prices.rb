class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.references :product, null: false, foreign_key: true
      t.string :stripe_price_id
      t.integer :unit_amount
      t.string :currency
      t.string :recurring

      t.timestamps
    end
  end
end
