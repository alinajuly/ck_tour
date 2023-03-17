class RenameTagNameToLocality < ActiveRecord::Migration[7.0]
  def change
    rename_column :tags, :name, :locality
  end
end
