class UsersController < ApplicationController

	def show
		 @member = User.find(params[:id])
     @reviews = UsersQuest.where(:assignee_id => @current_user.id)
	end

	def list
	end

	def new
		 @user = User.new
	end

  def edit
    @user = User.find(params[:id])
  end

	def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
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
