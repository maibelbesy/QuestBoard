class NotificationsController < ApplicationController
	def index
		Notification.remove_old @current_user
		Notification.where(:user_id => @current_user.id, :is_seen => false).update_all(:is_seen => true)
		@notifications = Notification.where(:user_id => @current_user.id).order('created_at DESC')
	end

	def seen
		request.body.rewind
		json = JSON.parse(request.body.read, symbolize_names: true)
		Notification.update(json[:id], :is_seen => true)
		render :nothing => true, :status => :ok
	end
end
