class User::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = User.find(params[:user_id])
  end
  
  def create
    @user = User.find(params[:user_id])
    unless current_user.blocking?(@user)
      current_user.follow(@user)
      # redirect_to request.referer
    else
      redirect_to user_path(@user), notice: "フォローするにはブロックの解除が必要です。"
    end
  end
  
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    # redirect_to request.referer
  end
  
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
  
end
