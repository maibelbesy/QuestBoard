<<<<<<< HEAD
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

ActiveRecord::Schema.define(version: 20150331171642) do

  create_table "connections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "connection_id"
    t.integer  "frequency",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["connection_id"], name: "index_connections_on_connection_id"
  add_index "connections", ["user_id"], name: "index_connections_on_user_id"

  create_table "quest_images", force: :cascade do |t|
    t.string   "caption"
    t.integer  "quest_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "quest_videos", force: :cascade do |t|
    t.string   "url"
    t.integer  "quest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quests", force: :cascade do |t|
    t.string   "title",                         null: false
    t.text     "description",   default: ""
    t.boolean  "is_completed",  default: false
    t.string   "bounty",        default: ""
    t.datetime "due_date"
    t.datetime "completed_at"
    t.string   "status",        default: ""
    t.integer  "bounty_points", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.boolean  "is_completed", default: false
    t.integer  "user_id"
    t.integer  "quest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["quest_id"], name: "index_tasks_on_quest_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "tokens", force: :cascade do |t|
    t.string   "key"
    t.string   "token_type", default: "access"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["key"], name: "index_tokens_on_key"
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username",                        null: false
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.boolean  "gender"
    t.string   "photo",           default: ""
    t.boolean  "email_verified",  default: false
    t.integer  "total_points",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["username"], name: "index_users_on_username"

  create_table "users_quests", force: :cascade do |t|
    t.integer  "assignor_id"
    t.integer  "assignee_id"
    t.integer  "quest_id"
    t.boolean  "is_accepted", default: false
    t.boolean  "is_rejected", default: false
    t.text     "review",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_quests", ["assignee_id"], name: "index_users_quests_on_assignee_id"
  add_index "users_quests", ["assignor_id", "assignee_id", "quest_id"], name: "index_users_quests_on_assignor_id_and_assignee_id_and_quest_id"
  add_index "users_quests", ["assignor_id"], name: "index_users_quests_on_assignor_id"
  add_index "users_quests", ["quest_id"], name: "index_users_quests_on_quest_id"

end
=======
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

ActiveRecord::Schema.define(version: 20150331171642) do

  create_table "connections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "connection_id"
    t.integer  "frequency",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["connection_id"], name: "index_connections_on_connection_id"
  add_index "connections", ["user_id"], name: "index_connections_on_user_id"

  create_table "messages", force: :cascade do |t|
    t.string   "author"
    t.text     "message"
    t.string   "timetoken"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title",      default: "Untitled notification"
    t.boolean  "is_seen",    default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "quest_images", force: :cascade do |t|
    t.string   "caption"
    t.integer  "quest_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "quest_videos", force: :cascade do |t|
    t.string   "url"
    t.integer  "quest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quests", force: :cascade do |t|
    t.string   "title",                         null: false
    t.text     "description",   default: ""
    t.boolean  "is_completed",  default: false
    t.string   "bounty",        default: ""
    t.datetime "due_date"
    t.datetime "completed_at"
    t.string   "status",        default: ""
    t.string   "gid"
    t.boolean  "remind_to",     default: false
    t.integer  "bounty_points", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", force: :cascade do |t|
    t.datetime "reminder"
    t.integer  "user_id"
    t.integer  "quest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["quest_id"], name: "index_reminders_on_quest_id"
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id"

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.boolean  "is_completed", default: false
    t.integer  "user_id"
    t.integer  "quest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["quest_id"], name: "index_tasks_on_quest_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "tokens", force: :cascade do |t|
    t.string   "key"
    t.string   "token_type", default: "access"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["key"], name: "index_tokens_on_key"
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username",                            null: false
    t.string   "email",                               null: false
    t.string   "password_digest",                     null: false
    t.boolean  "gender"
    t.string   "photo",               default: ""
    t.boolean  "email_verified",      default: false
    t.string   "provider"
    t.string   "guid"
    t.string   "oauth_token"
    t.string   "oauth_refresh_token"
    t.datetime "oauth_expires_at"
    t.integer  "points",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["username"], name: "index_users_on_username"

  create_table "users_quests", force: :cascade do |t|
    t.integer  "assignor_id"
    t.integer  "assignee_id"
    t.integer  "quest_id"
    t.boolean  "is_accepted", default: false
    t.boolean  "is_rejected", default: false
    t.text     "review",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_quests", ["assignee_id"], name: "index_users_quests_on_assignee_id"
  add_index "users_quests", ["assignor_id", "assignee_id", "quest_id"], name: "index_users_quests_on_assignor_id_and_assignee_id_and_quest_id"
  add_index "users_quests", ["assignor_id"], name: "index_users_quests_on_assignor_id"
  add_index "users_quests", ["quest_id"], name: "index_users_quests_on_quest_id"

end
>>>>>>> master
