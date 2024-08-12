class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @category = params[:category]
    @word = params[:word]
    if @category == "Post"
      if @word.present?
        @posts = Post.where(is_open: true).where("body LIKE?", "%#{@word}%")
      else
        @posts = []
        # =nil ではなく[]を使用。要素は無いが空の配列としてオブジェクトが存在。
      end
    elsif @category == "User"
      if @word.present?
        @users = User.where(is_active: true).where("name LIKE?", "%#{@word}%")
      else
        @users = []
      end
    else # @category == "Comment"
      if @word.present?
        @comments = Comment.where("comments.body LIKE?", "%#{@word}%")
      else
        @comments = []
      end
    end
  end
end
