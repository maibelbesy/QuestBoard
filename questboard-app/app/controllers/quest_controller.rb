class QuestsController < ApplicationController
	
def delete
end

def destroy
	@Uquest=UsersQuest.find_by_id(params[:id])
	#@currentU_id is the current user id (session)
	@currentU_id=session[:user_id]
	if(@Uquest.assignor_id== @currentU_id)
		UsersQuest.destroy(:quest_id => params[:id])
		Quest.destroy(:id=>params[:id])
		Task.destroy(:quest_id=>params[:id])
		#flash should be implemented in the view
		 flash[:notice] = "Quest is Deleted."
	else
	 flash[:notice] = "Quest wasn't deleted."
end

end