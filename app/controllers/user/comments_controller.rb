class User::CommentsController < ApplicationController

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_back(fallback_location: post_path(params[:post_id]))
    else
      Rails.logger.error @comment.errors.full_messages.inspect
      redirect_back(fallback_location: post_path(params[:post_id]))
    end
  end
  
  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    redirect_to post_path(params[:post_id])
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body, :stance, :post_id)
  end
end
