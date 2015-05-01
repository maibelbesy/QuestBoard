class CreateDb < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "username", :null => false, index: true
      t.string "email", :null => false, index: true
      t.string "password_digest", :null =>false
      t.boolean "gender"
      t.string "photo", default: ""
      t.boolean "email_verified", default: false
      t.string "provider"
      t.string "guid"
      t.string "oauth_token"
      t.string "oauth_refresh_token"
      t.datetime "oauth_expires_at"
      t.integer "points", default: 0
      t.timestamps
    end
  
    create_table :tokens do |t|
      t.string "key", index: true
      # t.integer "user_id"
      t.string "token_type", default: "access"
      t.belongs_to :user, index: true

      t.timestamps
    end

    create_table :quests do |t|
      t.string "title", :null => false
      t.text "description", default: ""
      t.boolean "is_completed", default: false
      t.string "bounty", default: ""
      t.datetime "due_date"
      t.datetime "completed_at"
      t.string "status", default: ""
      t.string "gid"
      t.boolean "remind_to", default: false
      t.integer "bounty_points", default: 0

      # t.integer "user_id"

      t.timestamps
    end

    create_table :tasks do |t|
      t.string "title"
      t.boolean "is_completed", default: false
      # t.integer "quest_id"
      t.belongs_to :user, index: true
      t.belongs_to :quest, index: true

      t.timestamps
    end

    create_table :users_quests do |t|
      t.integer "assignor_id", index: true
      t.integer "assignee_id", index: true
      t.integer "quest_id", index: true
      t.boolean "is_accepted", default: false
      t.boolean "is_rejected", default: false
      t.text "review", default: ""

      t.timestamps
    end

    create_table :connections do |t|
      t.integer "user_id", index: true
      t.integer "connection_id", index: true
      t.integer "frequency", default: 0

      t.timestamps
    end

    create_table :reminders do |t|
      t.datetime "reminder"
      t.belongs_to :user, index: true
      t.belongs_to :quest, index: true
      t.timestamps
    end

    create_table :notifications do |t|
      t.string "title", default: "Untitled notification"
      t.string "url"
      t.boolean "is_seen", default: false
      t.belongs_to :user, index: true

      t.timestamps
    end


    add_index :users_quests, ["assignor_id", "assignee_id", "quest_id"]
    # add_index :users,["email"]
    # add_index :tokens,["key"]
  end

end
