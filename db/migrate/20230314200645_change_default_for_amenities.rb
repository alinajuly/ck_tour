class ChangeDefaultForAmenities < ActiveRecord::Migration[7.0]
  def change
    change_column :amenities, :conditioner, :boolean, default: false
    change_column :amenities, :tv, :boolean, default: false
    change_column :amenities, :refrigerator, :boolean, default: false
    change_column :amenities, :kettle, :boolean, default: false
    change_column :amenities, :mv_owen, :boolean, default: false
    change_column :amenities, :hair_dryer, :boolean, default: false
    change_column :amenities, :nice_view, :boolean, default: false
    change_column :amenities, :inclusive, :boolean, default: false
  end
end
