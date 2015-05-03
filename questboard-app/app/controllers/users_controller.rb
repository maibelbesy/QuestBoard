class UsersController < ApplicationController

   def index
    if params[:search]
        @users = User.search(params[:search]).order("created_at DESC")
    else
        @users = User.all.order('created_at DESC')
    end
   end

# gathers all the required information about the user to view his/her profile
	def show
    @member = User.find(params[:id])
    conn = Connection.where(:user_id => @current_user.id).pluck(:connection_id)
    user = Connection.where(:connection_id => @current_user.id).pluck(:user_id)
    all = user + conn
    @connections = User.where(:id => all)
    @member = User.find(params[:id])
    @reviews = UsersQuest.where(:assignee_id => @current_user.id)
	end

# edit user profile view
  def edit
    @user = User.find(params[:id])
  end

# edit user profile
  def update
    @user = User.find(params[:id])
    user = User.find_by_email(current_user.email).try(:authenticate, params[:current_password])
    if user && @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
