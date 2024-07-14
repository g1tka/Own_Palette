class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.all.includes(:comments)
  end
  
  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
end
