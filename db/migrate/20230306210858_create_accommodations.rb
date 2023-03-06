class CreateAccommodations < ActiveRecord::Migration[7.0]
  def change
    create_table :accommodations do |t|
      t.string :name
      t.string :address
      t.string :description
      t.string :type
      t.integer :status
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
