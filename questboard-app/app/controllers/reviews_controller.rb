class ReviewsController < ApplicationController

 def index
		@users_quests.review = Review.all
	end

	def create
		Review.create(:name => params[:review])
		redirect_to :back
	end

	def destroy
		Review.destroy(params[:id])
		redirect_to :back
	end

end
