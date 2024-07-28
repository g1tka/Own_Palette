class Admin::CommentsController < ApplicationController
  def index
    @posts = Post.all.includes(:comments)
    @posts = @posts.left_outer_joins(:comments).group(:id).having('COUNT(comments.id) > 0').order('COUNT(comments.id) DESC')
    # .joinsのみでは、コメントが１つしか表示されないため、全て取得後コメント０のものを除外してコメント数の多い順に表示。
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
