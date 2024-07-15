class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.all.includes(:comments)
  end
  
  def destroy
    # showページ用
    @post = Post.all
    # index, showページ用
    @comment = Comment.find_by(params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
end
