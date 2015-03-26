class Quest < ActiveRecord::Base
	has_many :tasks, foreign_key: "quest_id", dependent: :destroy

	def self.create_personal_quest(args, user)
		quest = self.create(args)
		UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
	end

	def self.create_general_quest(args, user)
		if args[:assign_to].blank?
			Quest.create_personal_quest(args.execpt(:assign_to),user)

		else
			quest = self.create(args.except(:assign_to))
			id = User.find_by(:username => args[:assign_to]).id
			UsersQuest.create(:assignor_id => user.id, :assignee_id=>id, :quest_id => quest.id)
			
		end
	end 


end


