class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :locality
      t.string :street
      t.string :suite
      t.string :zip_code
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.references :geolocationable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
