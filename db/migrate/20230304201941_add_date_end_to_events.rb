class AddDateEndToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :date_end, :date
  end
end
