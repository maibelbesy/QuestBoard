class Quest < ActiveRecord::Base

	has_many :tasks, foreign_key: "task_id", dependent: :destroy

end
