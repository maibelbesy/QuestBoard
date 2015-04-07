class QuestsController < ApplicationController
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
    UsersQuest.update(params[:id],:is_accepted => true,:is_rejected => false)
    redirect_to quests_path
  end
def reject
    UsersQuest.update(params[:id],:is_accepted => false,:is_rejected => true)
    redirect_to quests_path
  end
def create
    hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
    hash[:assign_to] = params[:quest][:assign_to]
    puts params[:quest][:assign_to]
quest = Quest.create_general_quest(hash, @current_user)
    @quest = Quest.find(quest.quest_id)
    if params[:photos]
      #===== The magic is here ;)
      params[:photos].each { |photo|
        @quest.quest_images.create(:photo => photo)}
    end
    @quest.quest_videos.create(:url => params[:quest][:url])
    redirect_to quests_path
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
    Quest.update(params[:id], params.require(:quest).permit(:title, :description, :due_date, :bounty, :assign_to))
    redirect_to quests_path
  end
  # def delete
  # end
  def destroy
    @Uquest = UsersQuest.find_by_quest_id(params[:id])
    # @currentU_id is the current user id (session)
    # @currentU_id = session[:user_id]
    if(@Uquest.assignor_id == @current_user.id)
      UsersQuest.delete_all(:quest_id => params[:id])
      Quest.delete_all(:id => params[:id])
      Task.delete_all(:quest_id => params[:id])
    #flash should be implemented in the view
    # flash[:notice] = "Quest is Deleted."
    # else
    # flash[:notice] = "Quest wasn't deleted."
    end
    # Quest.delete_all(:id => params[:id])
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
