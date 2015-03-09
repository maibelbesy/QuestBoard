class QuestsController < ApplicationController

	def index 
		@quests = Quest.all
	end

	def show
		@quest = Quest.find(params[:id])
	end

	def create

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
		Quest.find(params[:id]).update(:title => hash[:title], :description => hash[:description], :user_id => 1)
		redirect_to quest_path(params[:id])
	end

	def destroy
		Quest.delete(params[:id])
		redirect_to quests_path
	end


end
