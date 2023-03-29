class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :price, null: false, foreign_key: true
      t.string :stripe_subscription_id
      t.integer :status

      t.timestamps
    end
  end
end
