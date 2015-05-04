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
      flash[:success] = []
      flash[:success] << "You profile was updated successfully."
      redirect_to @user
    else
      render 'edit'
    end
    # hash = params[:user]
    # @current_user.first_name = hash[:first_name]
    # @current_user.last_name = hash[:last_name]
    # if hash[:email] != @current_user.email
    #   flag = true
    #   @current_user.email = hash[:email]
    #   @current_user.email_verified = false
    # end
    # if @current_user.authenticate(hash[:current_password])
    #   if hash[:password] == hash[:password_confirmation]
    #     @current_password.password = hash[:password]
    #   else
    #     flash[:alert] = []
    #     flash[:alert] << "You profile was not updated successfully."
    #     redirect_to edit_user_path(@current_user.id) and return
    #   end
    # elsif !@current_user.authenticate(hash[:current_password])
    #   flash[:alert] = []
    #   flash[:alert] << "You profile was not updated successfully."
    #   redirect_to edit_user_path(@current_user.id) and return
    # end
    # flash[:success] = []
    # flash[:success] << "You profile was updated successfully."
    # @current_user.save
    # redirect_to user_path(@current_user.id) and return
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
