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

ActiveRecord::Schema.define(version: 20130802221712) do

  create_table "message_threads", force: true do |t|
    t.string   "uuid_1"
    t.string   "uuid_2"
    t.string   "mutual_friends"
    t.string   "mutual_friends_found"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "sender_uuid"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thread_id"
  end

end
