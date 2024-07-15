class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
  
  def toggle_status
    @post = Post.find(params[:id])
    # 公開←→非公開
    @post.update(is_open: !@post.is_open)
    
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  def show
    @post = Post.find(params[:id])
  end
end
