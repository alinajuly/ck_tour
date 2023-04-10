class ChangeColumnsInAmenities < ActiveRecord::Migration[7.0]
  def change
    add_column :amenities, :data, :jsonb
    remove_column :amenities, :conditioner, :boolean, default: false
    remove_column :amenities, :tv, :boolean, default: false
    remove_column :amenities, :refrigerator, :boolean, default: false
    remove_column :amenities, :kettle, :boolean, default: false
    remove_column :amenities, :mv_owen, :boolean, default: false
    remove_column :amenities, :hair_dryer, :boolean, default: false
    remove_column :amenities, :nice_view, :boolean, default: false
    remove_column :amenities, :inclusive, :boolean, default: false
  end
end
