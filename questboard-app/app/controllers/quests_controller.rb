class QuestsController < ApplicationController

	def index
		# TODO: Find personal quests
		quests = UsersQuest.where(:assignor_id => @current_user.id).pluck(:quest_id)
		@quests = Quest.where(:id => quests).order('due_date')
	end

	def pending_quests
		quests = UsersQuest.where(:assignee_id => @current_user.id).pluck(:quest_id)
		@quests = Quest.where(:id => quests).order('due_date')

	end


	def show
		@quest = Quest.find(params[:id])
	end

	def new
		# @quest = Quest.new
	end

	def create
		hash = params.require(:quest).permit(:title, :description, :due_date, :bounty)
		hash[:assign_to] = params[:quest][:assign_to]
		puts params[:quest][:assign_to]
		Quest.create_general_quest(hash, @current_user)

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
end
