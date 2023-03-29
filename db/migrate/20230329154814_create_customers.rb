class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
