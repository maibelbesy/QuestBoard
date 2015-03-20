
class Quest < ActiveRecord::Base


	

	has_many :tasks, foreign_key: "quests_id", dependent: :destroy


	def self.create_personal_quest(args)
		quest = self.create(args)
		# TODO: Implement the join table record creation here
		# UsersQuest.create(:assignor_id => @current_user.id, :assignee_id => @current_user.id, :quest_id => quest.id)
	end
end


