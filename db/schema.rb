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

ActiveRecord::Schema.define(version: 2021_12_20_221003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.string "username"
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "client_lessons", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "client_id", null: false
    t.bigint "lessons_type_id", null: false
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "credited_lesson_id", null: false
    t.bigint "coach_admin_id"
    t.integer "status"
    t.index ["client_id"], name: "index_client_lessons_on_client_id"
    t.index ["created_at"], name: "index_client_lessons_on_created_at"
    t.index ["credited_lesson_id"], name: "index_client_lessons_on_credited_lesson_id"
    t.index ["end_time"], name: "index_client_lessons_on_end_time"
    t.index ["lessons_type_id"], name: "index_client_lessons_on_lessons_type_id"
    t.index ["start_time", "end_time"], name: "index_client_lessons_on_start_time_and_end_time"
    t.index ["start_time"], name: "index_client_lessons_on_start_time"
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "address"
    t.integer "member_id"
    t.integer "fpp_id"
    t.string "phone_number"
    t.string "identification_number"
    t.string "nif"
    t.date "birth_date"
    t.string "rfid_number"
    t.text "comments"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "become_member_at"
    t.boolean "is_master_member", default: false
    t.boolean "is_deleted", default: false
    t.index ["birth_date"], name: "index_clients_on_birth_date"
    t.index ["created_at"], name: "index_clients_on_created_at"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["is_master_member"], name: "index_clients_on_is_master_member"
    t.index ["member_id"], name: "index_clients_on_member_id"
    t.index ["name"], name: "index_clients_on_name"
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "credited_lessons", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "lessons_type_id", null: false
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "time_period"
    t.decimal "payment", precision: 8, scale: 2, default: "0.0"
    t.decimal "lesson_price", precision: 8, scale: 2, default: "0.0"
    t.index ["client_id"], name: "index_credited_lessons_on_client_id"
    t.index ["created_at"], name: "index_credited_lessons_on_created_at"
    t.index ["lesson_price", "payment"], name: "index_credited_lessons_on_lesson_price_and_payment"
    t.index ["lesson_price"], name: "index_credited_lessons_on_lesson_price"
    t.index ["lessons_type_id"], name: "index_credited_lessons_on_lessons_type_id"
    t.index ["payment"], name: "index_credited_lessons_on_payment"
    t.index ["time_period"], name: "index_credited_lessons_on_time_period"
  end

  create_table "lessons_types", force: :cascade do |t|
    t.string "name"
    t.text "comments"
    t.decimal "green_time_member_price", precision: 8, scale: 2
    t.decimal "green_time_not_member_price", precision: 8, scale: 2
    t.decimal "red_time_member_price", precision: 8, scale: 2
    t.decimal "red_time_not_member_price", precision: 8, scale: 2
    t.boolean "is_pack"
    t.integer "number_of_lessons"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_active", default: true
    t.index ["is_active"], name: "index_lessons_types_on_is_active"
    t.index ["is_pack"], name: "index_lessons_types_on_is_pack"
    t.index ["name"], name: "index_lessons_types_on_name", unique: true
  end

  create_table "movements", force: :cascade do |t|
    t.bigint "voucher_id", null: false
    t.datetime "date"
    t.decimal "value", precision: 8, scale: 2, default: "0.0"
    t.string "description"
    t.text "comments"
    t.bigint "credited_lesson_id"
    t.boolean "from_credited_lesson"
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_movements_on_client_id"
    t.index ["credited_lesson_id"], name: "index_movements_on_credited_lesson_id"
    t.index ["date"], name: "index_movements_on_date"
    t.index ["voucher_id"], name: "index_movements_on_voucher_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.json "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vouchers", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.decimal "value", precision: 8, scale: 2, default: "0.0"
    t.text "comments"
    t.string "code"
    t.datetime "validity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "value_used", default: "0.0"
    t.index ["client_id"], name: "index_vouchers_on_client_id"
    t.index ["code"], name: "index_vouchers_on_code", unique: true
    t.index ["validity"], name: "index_vouchers_on_validity"
    t.index ["value", "value_used"], name: "index_vouchers_on_value_and_value_used"
    t.index ["value"], name: "index_vouchers_on_value"
    t.index ["value_used"], name: "index_vouchers_on_value_used"
  end

  add_foreign_key "client_lessons", "clients"
  add_foreign_key "client_lessons", "credited_lessons"
  add_foreign_key "client_lessons", "lessons_types"
  add_foreign_key "credited_lessons", "clients"
  add_foreign_key "credited_lessons", "lessons_types"
  add_foreign_key "movements", "clients"
  add_foreign_key "movements", "credited_lessons"
  add_foreign_key "movements", "vouchers"
  add_foreign_key "vouchers", "clients"
end
