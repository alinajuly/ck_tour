# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_14_175234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "description"
    t.string "kind"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "number_of_peoples"
    t.boolean "is_active"
    t.date "check_in"
    t.date "check_out"
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_bookings_on_room_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
  end

  create_table "coordinates", force: :cascade do |t|
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "coordinatable_type", null: false
    t.bigint "coordinatable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinatable_type", "coordinatable_id"], name: "index_coordinates_on_coordinatable"
  end

  create_table "places", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
  end

  create_table "rates", force: :cascade do |t|
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ratable_type", null: false
    t.bigint "ratable_id", null: false
    t.index ["ratable_type", "ratable_id"], name: "index_rates_on_ratable"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "places"
    t.string "bed"
    t.decimal "price_per_night"
    t.text "description"
    t.bigint "accommodation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "quantity"
    t.index ["accommodation_id"], name: "index_rooms_on_accommodation_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tagable_type", null: false
    t.bigint "tagable_id", null: false
    t.index ["tagable_type", "tagable_id"], name: "index_tags_on_tagable"
  end

  create_table "tours", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "rooms"
  add_foreign_key "rooms", "accommodations"
end
