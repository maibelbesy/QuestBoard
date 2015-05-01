class Task <ActiveRecord::Base
	belongs_to :quest, foreign_key: "quest_id"
	belongs_to :user, foreign_key: "user_id"

end