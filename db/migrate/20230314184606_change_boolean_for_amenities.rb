class ChangeBooleanForAmenities < ActiveRecord::Migration[7.0]
  def change
    change_column :amenities, :conditioner, :boolean, default: nil
    change_column :amenities, :tv, :boolean, default: nil
    change_column :amenities, :refrigerator, :boolean, default: nil
    change_column :amenities, :kettle, :boolean, default: nil
    change_column :amenities, :mv_owen, :boolean, default: nil
    change_column :amenities, :hair_dryer, :boolean, default: nil
    change_column :amenities, :nice_view, :boolean, default: nil
    change_column :amenities, :inclusive, :boolean, default: nil
  end
end
