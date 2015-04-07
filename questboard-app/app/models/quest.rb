class Quest < ActiveRecord::Base
	has_many :tasks, foreign_key: "quest_id", dependent: :destroy
	has_many :quest_images, :dependent => :destroy
	accepts_nested_attributes_for :quest_images, :reject_if => lambda { |t| t['quest_image'].nil? }
	
	has_many :quest_videos , :dependent => :destroy
	
	def self.create_general_quest(args, user)
		if args[:assign_to].blank?
			args.delete :assign_to
			quest = self.create(args)
			UsersQuest.create(:assignor_id => user.id, :assignee_id=>user.id, :quest_id => quest.id, :is_accepted => true)
		else
			quest = self.create(args.except(:assign_to))
			id = User.find_by(:username => args[:assign_to]).id
			UsersQuest.create(:assignor_id => user.id, :assignee_id=>id, :quest_id => quest.id)
		end
	end 
	
	def self.create_personal_quest(args, user)
		quest = self.create(args)
		UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
		quest
	end
end


