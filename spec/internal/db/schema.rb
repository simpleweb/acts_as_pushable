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

ActiveRecord::Schema.define(version: 20141202075742) do

  create_table "devices", force: :cascade do |t|
    t.string   "token"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "platform"
    t.boolean  "active",           default: true
    t.datetime "valid_at"
    t.datetime "invalidated_at"
    t.datetime "deleted_at"
    t.string   "platform_version"
    t.string   "platform_type"
    t.string   "push_environment"
    t.datetime "deactivated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["token"], name: "index_devices_on_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
