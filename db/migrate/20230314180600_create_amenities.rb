class CreateAmenities < ActiveRecord::Migration[7.0]
  def change
    create_table :amenities do |t|
      t.boolean :conditioner
      t.boolean :tv
      t.boolean :refrigerator
      t.boolean :kettle
      t.boolean :mv_owen
      t.boolean :hair_dryer
      t.boolean :nice_view
      t.boolean :inclusive

      t.timestamps
    end
  end
end
