class User::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = User.find(params[:user_id])
  end
  
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    # redirect_to request.referer
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
  
  def create_block
    @user = User.find(params[:user_id])
    current_user.block(@user)
    redirect_to request.referer
  end
  
  def destroy_block
    @user = User.find(params[:user_id])
    current_user.unblock(@user)
    redirect_to request.referer
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
