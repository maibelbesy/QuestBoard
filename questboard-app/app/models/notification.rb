class Notification < ActiveRecord::Base
	belongs_to :user

	def self.remove_old user
		if self.where(:user_id => user.id).count > 50
			notifs = self.where(:user_id => user.id).limit(50).pluck(:id)
			self.where.not(:id => notifs).delete_all
		end
	end
end
