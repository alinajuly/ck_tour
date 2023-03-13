class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :reg_code
      t.string :address
      t.string :person

      t.timestamps
    end
  end
end
