class CreateCaterings < ActiveRecord::Migration[7.0]
  def change
    create_table :caterings do |t|
      t.string :name
      t.text :description
      t.string :kind
      t.string :phone
      t.integer :places
      t.string :email
      t.string :reg_code
      t.string :address_owner
      t.string :person
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
