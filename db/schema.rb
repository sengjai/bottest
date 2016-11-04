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

ActiveRecord::Schema.define(version: 20161104080122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_users", force: :cascade do |t|
    t.integer  "bot_id"
    t.string   "cust_fb_id"
    t.integer  "msg_count",  default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "bots", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "uri"
    t.string   "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "page_id"
  end

  add_index "bots", ["user_id"], name: "index_bots_on_user_id", using: :btree

  create_table "question_answers", force: :cascade do |t|
    t.integer  "bot_id"
    t.text     "user_says"
    t.text     "bot_answers"
    t.text     "bot_answers_2"
    t.string   "keywords"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "mainkeywords",  default: [],              array: true
  end

  add_index "question_answers", ["bot_id"], name: "index_question_answers_on_bot_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name"
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
