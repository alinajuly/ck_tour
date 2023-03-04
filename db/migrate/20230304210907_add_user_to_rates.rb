class AddUserToRates < ActiveRecord::Migration[7.0]
  def change
    add_reference :rates, :user, null: false, foreign_key: true
  end
end
