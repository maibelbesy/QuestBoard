class QuestsController < ApplicationController
skip_before_filter  :verify_authenticity_token

  def index
    quests = UsersQuest.where(:assignor_id => @current_user.id, :assignee_id => @current_user.id).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
  end

  def my_quests
     quests = UsersQuest.where(:assignor_id => @current_user.id, :assignee_id => @current_user.id).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
  end

  def new
  end

  def edit
    @Quest = Quest.find(params[:id])
  end

  #destroy the specified quest and all of its dependencies
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

  # returns all the quests that are assigned by the user and to the users which are yet to be accepted
  def pending_quests
    quests = UsersQuest.where(:assignee_id => @current_user.id,:is_accepted => false,:is_rejected =>false).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
    by_me_quests = UsersQuest.where(:assignor_id => @current_user.id,:is_accepted => false,:is_rejected =>false).pluck(:quest_id)
    @by_me_quests = Quest.where(:id => by_me_quests).order('due_date')
  end


  #get all quests which are accepted
  def general_quests
    quests = UsersQuest.where(:assignee_id => @current_user.id,:is_accepted => true).where.not(:assignor_id => @current_user.id).pluck(:quest_id)
    @quests = Quest.where(:id => quests).order('due_date')
  end

  def assigned_quests
    quests = UsersQuest.where(:assignor_id => @current_user.id,:is_accepted => true).where.not(:assignee_id => @current_user.id).pluck(:quest_id)
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
    @Quest = Quest.find(@user_quest)
    @photos = @Quest.quest_images
    if QuestVideo.find_by_quest_id(@Quest.id).url != ""
    @video = QuestVideo.find_by_quest_id(@Quest.id).url.split('/').last
  else
    @video = ""
    end
    @tasks = @Quest.tasks
  end

  #Shows the Review related to certain Quest.
  def review
    @user_quest = UsersQuest.find(params[:id])
  end

  #Gives the User the option to write a review on a certain Quest.
  def add_review
    UsersQuest.update(params[:id], params.require(:quest).permit(:review))
    quest = Quest.find(params[:id])

    if params[:quest][:points] == "1"
      quest.bounty_points += 10
      quest.save
    end
    if params[:quest][:points] == "2"
      quest.bounty_points += 20
      quest.save
    end
    if params[:quest][:points] == "3"
      quest.bounty_points += 30
      quest.save
    end
    if params[:quest][:points] == "4"
      quest.bounty_points += 40
      quest.save
    end
    if params[:quest][:points] == "5"
      quest.bounty_points += 50
      quest.save
    end
    redirect_to quest_path(quest.id)
  end

# accepts the assigned quest, notifies the assignor, and increases the connection frequency
  def accept
    respond_to do |format|
      user_quest = UsersQuest.update(params[:id],:is_accepted => true,:is_rejected => false)
      @assignor_id = Connection.find_by("user_id = ? OR connection_id = ?", user_quest.assignor_id, user_quest.assignee_id)
      if @assignor_id == nil
        @assignor_id = Connection.create(:user_id => user_quest.assignor_id, :connection_id => user_quest.assignee_id)
      end
      @assignor_id.frequency += 1
      @assignor_id.save
      notif_user = User.find_by(:id => user_quest.assignor_id)
      notif = Notification.create(:user_id => user_quest.assignor_id,
        :title => "#{@current_user.first_name} #{@current_user.last_name} has accepted your assigned quest: #{Quest.find(params[:id]).title},
        :url => quest_path(user_quest.quest_id)")
      @options = {:channel => "/notifs/#{user_quest.assignor_id}",
                  :message => notif.title,
                  :count => "#{User.unread_notifications_count notif_user}", :redirect => quest_path(params[:id]),
                  :url => quest_path(user_quest.quest_id),
                  :id => notif.id}
      format.html {redirect_to quest_path(params[:id])}
      format.js
    end
  end

# rejects the assigned quest and notifies the assignor
  def reject
    respond_to do |format|
      user_quest = UsersQuest.update(params[:id],:is_accepted => false,:is_rejected => true)
      notif_user = User.find_by(:id => user_quest.assignor_id)
      notif = Notification.create(:user_id => user_quest.assignor_id,
        :title => "#{@current_user.first_name} #{@current_user.last_name} has rejected your assigned quest: #{Quest.find(params[:id]).title}",
        :url => quest_path(user_quest.quest_id))
      @options = {:channel => "/notifs/#{user_quest.assignor_id}",
                  :message => notif.title,
                  :count => "#{User.unread_notifications_count notif_user}", :redirect => quests_path,
                  :url => quest_path(user_quest.quest_id),
                  :id => notif.id}
      format.html {redirect_to quests_path}
      format.js
    end
  end

  #Gives the User the option to write a review on a certain Quest.
  def add_review
    UsersQuest.update(params[:id], params.require(:quest).permit(:review))
    redirect_to quest_path(params[:id])
  end

  #A User can create the Quest with a title, description, deadline, bounty and assign the Quest to another User.
  def create
    hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
    hash[:assign_to] = params[:quest][:assign_to]
    hash[:remind_to] = params[:quest][:remind_to]
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
      @quest = Quest.create_general_quest(hash, @current_user, params.require(:quest).permit(:reminder, :remind_to))
      Quest.assign_non_user @current_user, @quest, params[:quest][:assign_to] if non_user == true
      if params[:photos]

        params[:photos].each { |photo|
          @quest.quest_images.create(:photo => photo)
        }
      end
      @quest.quest_videos.create(:url => params[:quest][:url])
      if not hash[:assign_to].blank?
        user_quest = UsersQuest.find_by(:quest_id => @quest.id)
        notif_user = User.find_by(:id => user_quest.assignee_id)
        if notif_user == nil
          format.html {redirect_to quest_path(@quest.id)}
          @options = {:redirect => quest_path(@quest.id)}
          format.js
          return
        end
        notif = Notification.create(:user_id => user_quest.assignee_id,
                                    :title => "#{@current_user.first_name} #{@current_user.last_name} has assigned you a quest: #{@quest.title}",
                                    :url => quest_path(@quest.id))
        @options = {:channel => "/notifs/#{user_quest.assignee_id}",
                    :message => notif.title,
                    :count => "#{User.unread_notifications_count notif_user}", :redirect => quest_path(@quest.id),
                    :url => quest_path(@quest.id),
                    :id => notif.id}

        format.html {redirect_to quest_path(@quest.id)}
        format.js
      else
        @options = {:redirect => quest_path(@quest.id)}
        format.html {redirect_to quest_path(@quest.id)}
        format.js
      end
    end
  end

# update the content of the specified quest
  def update
    hash = params[:quest]
    flash[:warning] = []
    flash[:warning] << "Title cannot be left blank" if hash[:title].blank?
    redirect_to edit_quest_path and return if flash[:warning].count > 0
    Quest.update(params[:id], params.require(:quest).permit(:title, :description, :due_date,:bounty, :assign_to))
    quest = Quest.find_by_id(params[:id])
    if not quest.gid.blank?
      Quest.update_calendar_event quest, @current_user
    end
    redirect_to quests_path
  end

# Updates the quest's current status and tracks the number of quests each gender completes
  def status
    quest = Quest.find(params[:id])
    quest.update(:status=> params[:string])
    #update status in the db when it is done
    if (params[:string] == "Done")
      quest.is_completed=true
      quest.completed_at = DateTime.now.utc
      quest.save
      user = User.find(@current_user.id)
      user.points += 10
      user.save
      if @current_user.gender
        gender = 'male'
      else
        gender = 'female'
      end
      User.publish_event :gender, ({:gender => gender})

      userQuest=UsersQuest.find_by_quest_id(quest.id)
      if @current_user.id==userQuest.assignor_id && @current_user.id==userQuest.assignee_id
        User.publish_event :quest_type, ({:self_assigned => 'Self Assigned'})
      else
        User.publish_event :quest_type, ({:self_assigned => 'Not Self Assigned'})
      end   

    end
    redirect_to quest_path(params[:id])
  end
end
