class Review < ActiveRecord::Base
	belongs_to :users_quests, foreign_key: "users_quests_id"
end
