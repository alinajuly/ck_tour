class AddEmailToAccommodations < ActiveRecord::Migration[7.0]
  def change
    add_column :accommodations, :email, :string
  end
end
