class User::CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: post_path(params[:post_id]))
      # format.html { redirect_to @comment.post }
      # format.js
    else
      flash[:alert] = @comment.errors.full_messages.join(" / ")
      redirect_back(fallback_location: post_path(params[:post_id]))
      # format.html { redirect_to @comment.post, alert: @comment.errors.full_messages.jpin(",") }
      # format.js
    end
  end
  
  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    redirect_to post_path(params[:post_id])
  end
  
  def filter
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comments = @post.comments.where(stance: params[:comment][:stance])
    render "user/posts/show"
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body, :stance, :post_id)
  end
end
