class Quest < ActiveRecord::Base
	has_many :tasks, foreign_key: "quest_id", dependent: :destroy

	def self.create_personal_quest(args, user)
		quest = self.create(args)
		UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
		quest
	end

	def self.add_demo
		Quest.create(:title => "Demo")
	end
end


