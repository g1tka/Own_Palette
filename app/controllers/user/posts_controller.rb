class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def index
    if params[:color].present?
      if params[:color] == "7"
        @posts = Post.all
      else
        @posts = Post.where(color: params[:color])
      # if params[:color] == "0"
      #   @posts = Post.where(color: "red")
      # elsif params[:color] == "1"
      #   @posts = Post.where(color: "orange")
      # elsif params[:color] == "2"
      #   @posts = Post.where(color: "yellow")
      # elsif params[:color] == "3"
      #   @posts = Post.where(color: "green")
      # elsif params[:color] == "4"
      #   @posts = Post.where(color: "blue")
      # elsif params[:color] == "5"
      #   @posts = Post.where(color: "purple")
      # elsif params[:color] == "6"
      #   @posts = Post.where(color: "monochrome")
      # elsif params[:color] == "7"
      #   @posts = Post.where(color: "other")
      # else
      #   @posts = Post.all
      end
    else # 予期せぬ値が来た時のため記述
      @posts = Post.all
    end
  end

  def edit
    # :is_matching_login_user
  end
  
  def update
    # :is_matching_login_user
    @post.user_id = current_user.id
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end
  
  private
  def post_params
    params.require(:post).permit(:user_id, :image, :body, :color, :is_open)
  end
  
  def is_matching_login_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
