class TaskController < ApplicationController
	def index
		@quest = Quest.find(params[:id])
		@tasks = @quest.tasks
	end

	#creates a new task view
	def create
	end

	#creates a new task and redirects to the quest
	def create_task
	@task = Task.create(:quest_id => params[:id], :user_id => @current_user.id, :title => params[:task][:title])
	redirect_to quest_path(params[:id])
	end

	#deletes a task
	def destroy
		Task.destroy(params[:id])
		redirect_to quest_path(params[:id])
		
	end
end
