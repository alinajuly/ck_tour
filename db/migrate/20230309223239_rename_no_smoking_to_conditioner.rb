class RenameNoSmokingToConditioner < ActiveRecord::Migration[7.0]
  def change
    rename_column :rooms, :no_smoking, :conditioner
  end
end
