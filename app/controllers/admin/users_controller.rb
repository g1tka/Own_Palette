class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all
    
    case params[:sort_by]
    when "ids"
      @users = @users.order("id")
    when "names"
      @suers = @users.order("name")
    when "posts"
      @users = @users.left_joins(:posts).select("users.*, COUNT(posts.id) as posts_count").group(:id).order("posts_count DESC")
      # lest_joins 投稿数０でも表示するために。select()各ユーザーの投稿数をカウント。users.id, users.name...すべて＊
    else
      @users = @users.order(created_at: :desc)
    end
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
