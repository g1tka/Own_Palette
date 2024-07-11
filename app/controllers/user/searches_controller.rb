class User::SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @category = params[:category]
    @word = params[:word]
    if @category == 'Post'
      if @word.present?
        @posts = Post.where("body LIKE?", "%#{@word}%")
      else
        @posts = []
        # =nil ではなく[]を使用。要素は無いが空の配列としてオブジェクトが存在。
      end
    else #@category == 'User'
      if @word.present?
        @users = User.where("name LIKE?", "%#{@word}%")
      else
        @users = []
      end
    end
  end

end
