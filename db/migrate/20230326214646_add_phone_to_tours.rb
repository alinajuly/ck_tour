class AddPhoneToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :phone, :string
  end
end
