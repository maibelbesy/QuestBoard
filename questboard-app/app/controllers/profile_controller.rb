class ProfileController < ApplicationController
	def index
		@member = User.find(params[:id])
		# redirect_to index_path and return if !logged_in && @member.id != @current_user.id
	end
	
	
end
