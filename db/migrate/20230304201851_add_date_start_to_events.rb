class AddDateStartToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :date_start, :date
  end
end
