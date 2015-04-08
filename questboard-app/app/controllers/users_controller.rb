class UsersController < ApplicationController

  def index
    @users = User.all
  end

	def show
		 @user = User.find(params[:id])
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
