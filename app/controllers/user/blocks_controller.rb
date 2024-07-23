class User::BlocksController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = User.find(params[:user_id])
    current_user.block(@user)
    # redirect_to request.referer
  end
  
  def destroy
    @user = User.find(params[:user_id])
    current_user.unblock(@user)
    # redirect_to request.referer
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
