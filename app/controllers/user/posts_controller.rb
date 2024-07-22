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
    @comments = @post.comments
    if user_signed_in?
      @comment = current_user.comments.new
    else
      @comment = Comment.new
    end
  end

  def index
    if params[:color].present?
      if params[:color] == "7"
        @posts = Post.all.page(params[:page]).per(12)
      else
        @posts = Post.where(color: params[:color]).page(params[:page]).per(12)
      end
    else # 予期せぬ値が来た時のため記述
      @posts = Post.all.page(params[:page]).per(12)
    end
    
    case params[:sort_by]
    when 'newest'
      @posts = @posts.order(created_at: :desc)
    when 'oldest'
      @posts = @posts.order(created_at: :asc)
    when 'favorites'
      @posts = @posts.sort_by { |post| -post.favorites.count }
    when 'comments'
      @posts = @posts.sort_by { |post| -post.comments.count }
    else
      @posts = @posts.order(created_at: :desc)
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
