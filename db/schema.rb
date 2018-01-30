# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180130112927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "actions" because of following StandardError
#   Unknown type 'effect' for column 'effect'

  create_table "databases", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importer_session_items", id: :serial, force: :cascade do |t|
    t.integer "importer_session_id"
    t.integer "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importer_sessions", id: :serial, force: :cascade do |t|
    t.integer "importer_id"
    t.integer "user_id"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importers", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_field"
    t.string "amount_field"
    t.string "foreign_amount_field"
    t.string "description_field"
    t.string "encoding"
    t.string "column_separator", default: ","
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "importer_id"
    t.string "trigger", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["importer_id"], name: "index_rules_on_importer_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "db"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
