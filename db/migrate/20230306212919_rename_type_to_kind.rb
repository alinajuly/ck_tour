class RenameTypeToKind < ActiveRecord::Migration[7.0]
  def change
    rename_column :accommodations, :type, :kind
  end
end
