class CreateDb < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string "first_name"
  		t.string "last_name"
  		t.string "user_name", :null => false
  		t.string "email", :null => false
  		t.string "password_digest", :null =>false
  		t.boolean "gender"
  		t.string "photo"
  		t.boolean "email_verified"

  		t.timestamps
  	end
  
  	create_table :tokens do |t|
  		t.string "key"
  		# t.integer "user_id"
  		t.string "token_type"

      t.belongs_to :users

  		t.timestamps
  	end

  	create_table :quests do |t|
  		t.string "title", :null => false
  		t.text "description"
  		t.boolean "is_completed"
  		t.string "bounty"
  		t.datetime "due_date"
      t.datetime "completed_at"
  		t.string "status"
  		# t.integer "user_id"

  		t.timestamps
  	end

  	create_table :tasks do |t|
  		t.text "description"
  		t.boolean "is_completed"
  		# t.integer "quest_id"
      t.belongs_to :users
      t.belongs_to :quests

  		t.timestamps
  	end

  	create_table :users, :quests do |t|
  		t.integer "assignor_id"
  		t.integer "assignee_id"
  		t.boolean "is_accepted"
  		t.integer "quest_id"
  		t.text "review"

  		t.timestamps
  	end
  	
   add_index :users,["user_name","email"]
   add_index :tokens,["token_id"]
  end

end
