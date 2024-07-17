class User::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_authorization, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    # 自分の投稿を表示する状態がdefault
    @filter = params[:filter] || "own"
    
    case @filter
    when "own"
      @posts = @user.posts
    when "favorites"
      @posts = current_user.favorite_posts
    when "all"
      @posts = Post.where(user: @user).or(Post.where(id: current_user.favorite_posts.pluck(:id)))
    else
      @posts = @user.posts
    end
  end
  
  def edit
    # check_authorization
  end
  
  def update
    # check_authorization
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
  
  def check_authorization
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
