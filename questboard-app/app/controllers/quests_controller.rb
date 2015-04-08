class QuestsController < ApplicationController

  def index
    # TODO: Find personal quests
    quests = UsersQuest.where(:assignor_id => @current_user.id, :assignee_id => @current_user.id).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
  end

  def new
    # @quest = Quest.new
  end

  # def create
  #   Quest.create_personal_quest(params.require(:quest).permit(:title, :description, :due_date, :remind_to), @current_user, params.require(:quest).permit(:reminder))
  #   # user = User.last
  #   # puts "CONNECTED #{user.google_connected?}"
  #   # puts "TOKEN #{user.fresh_token}"
  #   redirect_toa quests_path
  # end

  def edit
    @quest = Quest.find(params[:id])
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
    end
    redirect_to quests_path
  end

  #get all quests which arent accepted yet
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


  #get all quests which are accepted
  def general_quests
    quests = UsersQuest.where(:assignee_id => @current_user.id,:is_accepted => true).where.not(:assignor_id => @current_user).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
  end

	#Shows all information about a Quest. 
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
		@tasks = @quest.tasks
	end

	#Shows the Review related to certain Quest.
	def review
		#TODO On Event (done Quest)
		# @user_to_review = UsersQuest.find(params[:id]).review
		@user_quest = UsersQuest.find(params[:id])
	 #redirect_to quests_path
	end

	def accept

		respond_to do |format|
			user_quest = UsersQuest.update(params[:id],:is_accepted => true,:is_rejected => false)
			# redirect_to quests_path
      @assignor_id = Connections.find_or_initialize_by(:user_id => params[:id])
      @assignor_id.frequency += 1
      @assignor_id.save
			notif = Notification.create(:user_id => user_quest.assignor_id, :title => "#{@current_user.first_name} #{@current_user.last_name} has accepted your assigned quest: #{Quest.find(params[:id]).title}")
			@options = {:channel => "/notifs/#{user_quest.assignor_id}",
								:message => notif.title,
								:count => "#{User.unread_notifications_count @current_user}", :redirect => quests_path}
			format.html {redirect_to quests_path}
			format.js
		end
		
		# Connection.where("user_id = ? Or connection_id = ?" @current_user,@current_user)
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
	#Gives the User the option to write a review on a certain Quest.
	def add_review
		#@user_quest = UsersQuest.find(params[:id])
		UsersQuest.update(params[:id], params.require(:quest).permit(:review))
  end

	#A User can create the Quest with a title, description, deadline, bounty and assign the Quest to another User.
	def create
		hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
		hash[:assign_to] = params[:quest][:assign_to]
		puts params[:quest][:assign_to] 
		quest = Quest.create_general_quest(hash, @current_user)
		@quest = Quest.find(quest.quest_id)
    if params[:photos]
      #===== The magic is here ;)
      params[:photos].each { |photo|
        @quest.quest_images.create(:photo => photo)
      }
    end
    @quest.quest_videos.create(:url => params[:quest][:url])
    if not hash[:assign_to].blank?
      respond_to do |format|
        user_quest = UsersQuest.find_by(:quest_id => @quest.id)
        notif = Notification.create(:user_id => user_quest.assignee_id, 
        :title => "#{@current_user.first_name} #{@current_user.last_name} has assigned you a quest: #{@quest.title}")
        @options = {:channel => "/notifs/#{user_quest.assignee_id}",
        :message => notif.title,
        :count => "#{User.unread_notifications_count User.find_by(:id => user_quest.assignee_id)}", :redirect => quests_path}
        format.html {redirect_to quests_path}
        format.js
      end
    else
      redirect_to quests_path
    end  
  end


  def update
    hash = params[:quest]
    flash[:warning] = []
    flash[:warning] << "Title cannot be left blank" if hash[:title].blank?
    # flash[:warning] << "Content cannot be left blank" if hash[:description].blank?
    redirect_to edit_quest_path and return if flash[:warning].count > 0
    # Quest.find(params[:id]).update(:title => hash[:title], :description => hash[:description], :is_completed => hash[:is_completed], :bounty => hash[:bounty], :due_date => hash[:due_date] )
    Quest.update(params[:id], params.require(:quest).permit(:title, :description, :due_date,:bounty, :assign_to))
    quest = Quest.find_by_id(params[:id])
    if not quest.gid.blank?
      Quest.update_calendar_event quest, @current_user
    end
    redirect_to quests_path
  end

  def status
    quest = Quest.find(params[:id])
    quest.update(:status=> params[:string])
    #update status in the db when it is done
    if (params[:string] == "Done")
    quest.is_completed=true
    quest.save
    user = User.find(@current_user.id)
    user.points += 10
    user.save
    end
    redirect_to quests_path
  end

end
