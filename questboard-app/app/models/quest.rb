
class Quest < ActiveRecord::Base

	has_many :tasks, foreign_key: "quests_id", dependent: :destroy

end


