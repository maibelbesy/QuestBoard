class TaskController < ApplicationController
	def index
		@quest = Quest.find(params[:id])
		@tasks = @quest.tasks
	end

	def create
		 # @task = Task.create(:quest_id => params[:id], :user_id => @current_user.id, :title => params[:task][:title])
	end

	def create_task
	@task = Task.create(:quest_id => params[:id], :user_id => @current_user.id, :title => params[:task][:title])
	redirect_to quest_path(params[:id])
	end

	def destroy
		Task.destroy(params[:id])
		redirect_to quest_path(params[:id])
		
	end
end
