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

ActiveRecord::Schema.define(version: 2021_11_22_104426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username"
    t.integer "role"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admins_on_role"
    t.index ["username", "email"], name: "index_admins_on_username_and_email"
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "email", default: "", null: false
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
    t.index ["birth_date"], name: "index_clients_on_birth_date"
    t.index ["created_at"], name: "index_clients_on_created_at"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["is_master_member"], name: "index_clients_on_is_master_member"
    t.index ["member_id"], name: "index_clients_on_member_id"
    t.index ["name"], name: "index_clients_on_name"
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.decimal "green_time_member_price", precision: 8, scale: 2
    t.decimal "green_time_not_member_price", precision: 8, scale: 2
    t.decimal "red_time_member_price", precision: 8, scale: 2
    t.decimal "red_time_not_member_price", precision: 8, scale: 2
    t.string "name"
    t.integer "number"
    t.boolean "is_pack"
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

end
