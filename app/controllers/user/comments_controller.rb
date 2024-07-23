class User::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    unless @post.user.blocking?(current_user)
      @comment = current_user.comments.new(comment_params)
      if @comment.save
        redirect_back(fallback_location: post_path(params[:post_id]))
      else
        flash[:alert] = @comment.errors.full_messages.join(" / ")
        redirect_back(fallback_location: post_path(params[:post_id]))
      end
    else
      flash[:error] = "この投稿にはコメントできなくなりました。"
      redirect_back(fallback_location: post_path(params[:post_id]))
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
