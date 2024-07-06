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
    if params[:color].present?
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
      # end
    else
      @posts = Post.all
    end
  end

  def edit
  end
  
  private
  def post_params
    params.require(:post).permit(:user_id, :image, :body, :color, :is_open)
  end
end
