class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.integer :number_of_peoples
      t.datetime :check_in
      t.datetime :check_out
      t.string :note
      t.references :user, null: false, foreign_key: true
      t.references :catering, null: false, foreign_key: true
      t.integer :confirmation, default: 0
      t.timestamps
    end
  end
end
