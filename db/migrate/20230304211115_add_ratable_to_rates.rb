class AddRatableToRates < ActiveRecord::Migration[7.0]
  def change
    add_reference :rates, :ratable, polymorphic: true, null: false
  end
end
