class User::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def withdraw
    @user = current_user
    @user.update(is_active: false)
    reset_session
    redirect_to new_user_registration_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
