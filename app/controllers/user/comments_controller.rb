class User::CommentsController < ApplicationController
  include WordFilter

  def create
    @post = Post.find(params[:post_id])
    unless @post.user.blocking?(current_user)
      ng_words = load_ng_words("#{Rails.root}/ng_words.txt")
      @comment = current_user.comments.new(comment_params)
      # API language導入。
      @comment.score = Language.get_data(comment_params[:body])
      
      @comment.body = filter_ng_words(params[:comment][:body].downcase, ng_words)
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
    # filterアクションとして選択されたスタンスごとに表示
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    if params[:comment].present? && params[:comment][:stance].present? && params[:comment][:stance] != "clear"
      @comments = @post.comments.where(stance: params[:comment][:stance])
    else
      @comments = @post.comments
    end
    render "user/posts/show"
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :stance, :post_id)
    end
end
