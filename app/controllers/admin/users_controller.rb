class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def user_ban
    @user = User.find(params[:id])
    # 有効←→退会済み
    @user.update(is_active: !@user.is_active)

    respond_to do |format|
      format.js
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
end
