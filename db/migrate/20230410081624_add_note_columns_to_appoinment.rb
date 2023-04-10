class AddNoteColumnsToAppoinment < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :note, :string
  end
end
