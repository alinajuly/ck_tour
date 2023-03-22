class DropPartners < ActiveRecord::Migration[7.0]
  def change
    drop_table :partners do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :reg_code
      t.string :address
      t.string :person
      t.timestamps null: false
    end
  end
end
