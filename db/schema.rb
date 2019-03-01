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

ActiveRecord::Schema.define(version: 2019_02_28_205806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affairs", force: :cascade do |t|
    t.string "file_number"
    t.date "start_date"
    t.date "finish_date"
    t.string "status"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_affairs_on_client_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "affair_id"
    t.bigint "attorney_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affair_id", "attorney_id"], name: "index_assignments_on_affair_id_and_attorney_id", unique: true
    t.index ["affair_id"], name: "index_assignments_on_affair_id"
    t.index ["attorney_id"], name: "index_assignments_on_attorney_id"
  end

  create_table "attorneys", force: :cascade do |t|
    t.string "dni"
    t.string "full_name"
    t.string "address"
    t.string "nacionality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "dni"
    t.string "full_name"
    t.string "address"
    t.string "nacionality"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "affairs", "clients"
  add_foreign_key "assignments", "affairs"
  add_foreign_key "assignments", "attorneys"
end
