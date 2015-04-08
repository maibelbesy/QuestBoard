class QuestsController < ApplicationController
	require 'eventmachine'

	def index
		# TODO: Find personal quests
		quests = UsersQuest.where(:assignor_id => @current_user.id).pluck(:quest_id)
		@quests = Quest.where(:id => quests).order('due_date')
	end

	def pending_quests
		quests = UsersQuest.where(:assignee_id => @current_user.id,:is_accepted => false,:is_rejected =>false).pluck(:quest_id)
		@quests = Quest.where(:id => quests).order('due_date')
		by_me_quests = UsersQuest.where(:assignor_id => @current_user.id,:is_accepted => false,:is_rejected =>false).pluck(:quest_id)
		@by_me_quests = Quest.where(:id => by_me_quests).order('due_date')
	end

	def general_quests
		quests = UsersQuest.where(:assignee_id => @current_user.id,:is_accepted => true).where.not(:assignor_id => @current_user).pluck(:quest_id)
		@quests = Quest.where(:id => quests).order('due_date')
	end


	def show
		@user_quest = UsersQuest.find(params[:id])
		@assignor_id = UsersQuest.find(params[:id]).assignor_id
		@assignee_id = UsersQuest.find(params[:id]).assignee_id
		@is_accepted = UsersQuest.find(params[:id]).is_accepted
		@is_rejected = UsersQuest.find(params[:id]).is_rejected
		@name = User.find(@user_quest.assignee_id)
		@quest = Quest.find(@user_quest)
		@photos = @quest.quest_images
		@video = QuestVideo.find_by_quest_id(@quest.id).url.split('/').last
	end

	def new
		# @quest = Quest.new
	end

	def accept
		respond_to do |format|
			user_quest = UsersQuest.update(params[:id],:is_accepted => true,:is_rejected => false)
			# redirect_to quests_path
			notif = Notification.create(:user_id => user_quest.assignor_id, :title => "#{@current_user.first_name} #{@current_user.last_name} has accepted your assigned quest: #{Quest.find(params[:id]).title}")
			@options = {:channel => "/notifs/#{user_quest.assignor_id}",
								:message => notif.title,
								:count => "#{User.unread_notifications_count @current_user}", :redirect => quests_path}
			format.html {redirect_to quests_path}
			format.js
		end
	end

	def reject
		respond_to do |format|
			user_quest = UsersQuest.update(params[:id],:is_accepted => false,:is_rejected => true)
			# redirect_to quests_path
			notif = Notification.create(:user_id => user_quest.assignor_id, :title => "#{@current_user.first_name} #{@current_user.last_name} has rejected your assigned quest: #{Quest.find(params[:id]).title}")
			@options = {:channel => "/notifs/#{user_quest.assignor_id}",
								:message => notif.title,
								:count => "#{User.unread_notifications_count @current_user}", :redirect => quests_path}
			format.html {redirect_to quests_path}
			format.js
		end
	end

	# def create
 #   # hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
 #   # hash[:assign_to] = params[:quest][:assign_to]
 #   # puts params[:quest][:assign_to]
 #   if not params[:quest][:assign_to].blank?
 #     user = User.find_by(:username => params[:quest][:assign_to])
 #     if  user == nil
 #       flash[:notice] = 'No assinee with this user name'
 #       redirect_to create_quest_path and return 
 #     end
 #   end
 #   quest = Quest.create_general_quest(hash, @current_user)
 #   @quest = Quest.find(quest.quest_id)
 #   if params[:photos]
 #     #===== The magic is here :wink:
 #     params[:photos].each { |photo|
 #       @quest.quest_images.create(:photo => photo)
 #     }
 #   end
 #   @quest.quest_videos.create(:url => params[:quest][:url])
 #   redirect_to quests_path
 # end


	def create
		hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
		hash[:assign_to] = params[:quest][:assign_to]
		respond_to do |format|
			if not params[:quest][:assign_to].blank?
				if params[:quest][:assign_to] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
					user = User.find_by(:email => params[:quest][:assign_to])
					if user == nil
						if params[:quest][:assign_to] =~ /^\S+@gmail.com$/
							non_user = true
						else
							flash[:notice] = 'No assinee with this email'
							format.html {redirect_to create_quest_path and return}
							@options = {:redirect => create_quest_path}
							format.js
							return
						end
					end
				else
					user = User.find_by(:username => params[:quest][:assign_to])
					if  user == nil
						flash[:notice] = 'No assinee with this username'
						# redirect_to create_quest_path and return 
						format.html {redirect_to create_quest_path and return}
						@options = {:redirect => create_quest_path}
						format.js
						return
					end
				end
			end
			@quest = Quest.create_general_quest(hash, @current_user, params.require(:quest).permit(:reminder))
			Quest.assign_non_user @current_user, @quest, params[:quest][:assign_to] if non_user == true
			# @quest = Quest.find(quest.quest_id)
			if params[:photos]
				#===== The magic is here ;)
				params[:photos].each { |photo|
					@quest.quest_images.create(:photo => photo)
				}
			end
			@quest.quest_videos.create(:url => params[:quest][:url])
			# redirect_to quests_path
			if not hash[:assign_to].blank? 
					user_quest = UsersQuest.find_by(:quest_id => @quest.id)
					notif_user = User.find_by(:id => user_quest.assignee_id)
					if notif_user == nil
						format.html {redirect_to quests_path}
						@options = {:redirect => quests_path}
						format.js
						return
					end
					notif = Notification.create(:user_id => user_quest.assignee_id, 
						:title => "#{@current_user.first_name} #{@current_user.last_name} has assigned you a quest: #{@quest.title}")
					@options = {:channel => "/notifs/#{user_quest.assignee_id}",
										:message => notif.title,
										:count => "#{User.unread_notifications_count notif_user}", :redirect => quests_path}
					format.html {redirect_to quests_path}
					format.js
			else
				@options = {:redirect => quests_path}
				format.html {redirect_to quests_path}
				format.js
			end
		end
	end

	def edit
		@quest = Quest.find(params[:id])
	end

	def update
		hash = params[:quest]
		flash[:warning] = []
		flash[:warning] << "Title cannot be left blank" if hash[:title].blank?
		# flash[:warning] << "Content cannot be left blank" if hash[:description].blank?
		redirect_to edit_quest_path and return if flash[:warning].count > 0
		# Quest.find(params[:id]).update(:title => hash[:title], :description => hash[:description], :is_completed => hash[:is_completed], :bounty => hash[:bounty], :due_date => hash[:due_date] )
		Quest.update(params[:id], params.require(:quest).permit(:title, :description, :due_date))
		quest = Quest.find_by_id(params[:id])
		if not quest.gid.blank?
			Quest.update_calendar_event quest, @current_user
		end
		redirect_to quests_path
	end

def destroy
	@Uquest = UsersQuest.find_by_quest_id(params[:id])
	if(@Uquest.assignor_id == @current_user.id)
		quest = Quest.find_by_id(params[:id])
		if not quest.gid.blank?
			Quest.delete_calendar_event quest, @current_user
		end
		UsersQuest.delete_all(:quest_id => params[:id])
		Quest.delete_all(:id => params[:id])
		Task.delete_all(:quest_id => params[:id])
		Reminder.delete_all(:quest_id => params[:id])
		#flash should be implemented in the view
		# flash[:notice] = "Quest is Deleted."
	# else
		# flash[:notice] = "Quest wasn't deeted."
	end
	# Quest.delete_all(:id => params[:id])
	redirect_to quests_path
	end
	
end

