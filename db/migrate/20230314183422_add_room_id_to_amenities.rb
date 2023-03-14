class AddRoomIdToAmenities < ActiveRecord::Migration[7.0]
  def change
    add_reference :amenities, :room, null: false, foreign_key: true
  end
end
