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

ActiveRecord::Schema[7.0].define(version: 2023_04_08_005534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "kind"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "email"
    t.bigint "user_id", null: false
    t.string "reg_code"
    t.string "address_owner"
    t.string "person"
    t.index ["user_id"], name: "index_accommodations_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "amenities", force: :cascade do |t|
    t.boolean "conditioner", default: false
    t.boolean "tv", default: false
    t.boolean "refrigerator", default: false
    t.boolean "kettle", default: false
    t.boolean "mv_owen", default: false
    t.boolean "hair_dryer", default: false
    t.boolean "nice_view", default: false
    t.boolean "inclusive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id", null: false
    t.index ["room_id"], name: "index_amenities_on_room_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "number_of_peoples"
    t.bigint "user_id", null: false
    t.bigint "tour_id", null: false
    t.integer "confirmation", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id"], name: "index_appointments_on_tour_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "attractions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "number_of_peoples"
    t.date "check_in"
    t.date "check_out"
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.integer "confirmation", default: 0
    t.index ["room_id"], name: "index_bookings_on_room_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "caterings", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "kind"
    t.string "phone"
    t.integer "places"
    t.string "email"
    t.string "reg_code"
    t.string "address_owner"
    t.string "person"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_caterings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.bigint "user_id", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.datetime "checkin_start", precision: nil
    t.datetime "checkin_end", precision: nil
    t.datetime "checkout_start", precision: nil
    t.datetime "checkout_end", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accommodation_id", null: false
    t.boolean "credit_card", default: false
    t.boolean "free_parking", default: false
    t.boolean "wi_fi", default: false
    t.boolean "breakfast", default: false
    t.boolean "pets", default: false
    t.index ["accommodation_id"], name: "index_facilities_on_accommodation_id"
  end

  create_table "geolocations", force: :cascade do |t|
    t.string "locality"
    t.string "street"
    t.string "suite"
    t.string "zip_code"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "geolocationable_type", null: false
    t.bigint "geolocationable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geolocationable_type", "geolocationable_id"], name: "index_geolocations_on_geolocationable"
  end

  create_table "places", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tour_id", null: false
    t.string "name"
    t.index ["tour_id"], name: "index_places_on_tour_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "ratable_type", null: false
    t.bigint "ratable_id", null: false
    t.index ["ratable_type", "ratable_id"], name: "index_rates_on_ratable"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "number_of_peoples"
    t.datetime "check_in"
    t.datetime "check_out"
    t.string "note"
    t.bigint "user_id", null: false
    t.bigint "catering_id", null: false
    t.integer "confirmation", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catering_id"], name: "index_reservations_on_catering_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
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

  create_table "tours", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "reg_code"
    t.string "address_owner"
    t.string "person"
    t.text "description"
    t.integer "seats"
    t.decimal "price_per_one"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string "email"
    t.integer "status", default: 0
    t.string "phone"
    t.index ["user_id"], name: "index_tours_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "role", default: 0
    t.string "stripe_id"
  end

  add_foreign_key "accommodations", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "amenities", "rooms"
  add_foreign_key "appointments", "tours"
  add_foreign_key "appointments", "users"
  add_foreign_key "bookings", "rooms"
  add_foreign_key "bookings", "users"
  add_foreign_key "caterings", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "facilities", "accommodations"
  add_foreign_key "places", "tours"
  add_foreign_key "rates", "users"
  add_foreign_key "reservations", "caterings"
  add_foreign_key "reservations", "users"
  add_foreign_key "rooms", "accommodations"
  add_foreign_key "tours", "users"
end
