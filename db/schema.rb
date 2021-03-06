# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20171206152952) do

  create_table "kingakus", force: :cascade do |t|
    t.integer  "kingaku"
    t.text     "memo"
    t.datetime "created_at", null: false
    t.integer  "member_id"
    t.integer  "list_id"
    t.datetime "updated_at", null: false
  end

  add_index "kingakus", ["list_id"], name: "index_kingakus_on_list_id"
  add_index "kingakus", ["member_id"], name: "index_kingakus_on_member_id"

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.string   "url_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lists", ["url_hash"], name: "index_lists_on_url_hash"

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["list_id"], name: "index_members_on_list_id"

  create_table "paids", force: :cascade do |t|
    t.integer  "kingaku"
    t.string   "memo"
    t.integer  "pay_member_id",     null: false
    t.integer  "recieve_member_id", null: false
    t.integer  "list_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "paids", ["list_id"], name: "index_paids_on_list_id"
  add_index "paids", ["pay_member_id"], name: "index_paids_on_pay_member_id"
  add_index "paids", ["recieve_member_id"], name: "index_paids_on_recieve_member_id"

  create_table "whos", force: :cascade do |t|
    t.integer  "kingaku_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "whos", ["kingaku_id"], name: "index_whos_on_kingaku_id"
  add_index "whos", ["member_id"], name: "index_whos_on_member_id"

end
