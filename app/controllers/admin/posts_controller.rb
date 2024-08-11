class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @posts = Post.all

    case params[:sort_by]
    when "newest"
      @posts = @posts.order(created_at: :desc)
    when "oldest"
      @posts = @posts.order(created_at: :asc)
    when "comments"
      @posts = @posts.left_outer_joins(:comments).group(:id).order("COUNT(comments.id) DESC")
    else
      @posts = @posts.order(created_at: :desc)
    end
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
