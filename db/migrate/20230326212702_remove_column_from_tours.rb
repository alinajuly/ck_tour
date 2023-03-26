class RemoveColumnFromTours < ActiveRecord::Migration[7.0]
  def change
    remove_column :tours, :body, :text
    remove_column :tours, :status, :integer
  end
end
