class ChangeRatingDefaultInRates < ActiveRecord::Migration[7.0]
  def change
    change_column :rates, :rating, :integer, default: 0
  end
end
