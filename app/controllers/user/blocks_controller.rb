class User::BlocksController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.block(@user)
    if current_user.following?(@user)
      current_user.unfollow(@user)
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unblock(@user)
  end

  def blockings
    user = User.find(params[:user_id])
    @users = user.blockings
  end

  def blockers
    user = User.find(params[:user_id])
    @users = user.blockers
  end
end
