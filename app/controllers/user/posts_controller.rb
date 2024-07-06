class User::PostsController < ApplicationController
  def index
  end

  def new
    @post = Post.new
  end

  def show
  end

  def edit
  end
  
  private
  def post_params
    params.require(:post).permit(:)
  end
end
