class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.all.includes(:comments)
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
  
  # posts/show画面におけるcommentの削除
  def destroy_comment
    @post = Post.find(params[:id])
    @comment = Comment.find_by(params[:id])
    @comment.destroy
    redirect_to admin_post_path(@post)
  end
end
