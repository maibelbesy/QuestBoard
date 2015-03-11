class Quest < ActiveRecord::Base

	has_many :tasks, dependent: :destroy

	def create_personal_quest(args)
		quest = self.create(args)
		# Implement the join table record creation here
	end
end
