class QuestsController < ApplicationController

	def index
		# TODO: Find personal quests
		@quests = Quest.all.order('due_date')
	end

	def show
		@quest = Quest.find(params[:id])
	end

	def new
		# @quest = Quest.new
	end

	def create
		Quest.create_personal_quest(params.require(:quest).permit(:title, :description, :due_date))
		redirect_to quests_path
	end

	def edit
		@quest = Quest.find(params[:id])
	end

	def update
		hash = params[:quest]
		flash[:warning] = []
		flash[:warning] << "Title cannot be left blank" if hash[:title].blank?
		flash[:warning] << "Content cannot be left blank" if hash[:description].blank?
		redirect_to edit_quest_path and return if flash[:warning].count > 0
		# Quest.find(params[:id]).update(:title => hash[:title], :description => hash[:description], :is_completed => hash[:is_completed], :bounty => hash[:bounty], :due_date => hash[:due_date] )
		Quest.update(params[:id], params.require(:quest).permit(:title, :description, :due_date))
		redirect_to quests_path
	end

	def destroy
		Quest.delete(params[:id])
		redirect_to quests_path
	end

end
