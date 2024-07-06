class User::PostsController < ApplicationController
  def index
  end

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
    @posts = Post.all
  end

  def edit
  end
  
  private
  def post_params
    params.require(:post).permit(:user_id, :image, :body, :color, :is_open)
  end
end
