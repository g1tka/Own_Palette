class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :is_matching_login_user, only: [:edit, :update]

  include WordFilter

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    ng_words = load_ng_words("#{Rails.root}/ng_words.txt")
    @post.body = filter_ng_words(params[:post][:body].downcase, ng_words)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    unless @post.user == current_user
      @posts = Post.where(is_open: true)
    end
    @comments = @post.comments
    if user_signed_in?
      @comment = current_user.comments.new
    else
      @comment = Comment.new
    end
  end

  def index
    if params[:color].present?
      if params[:color] == "7"
        @posts = Post.all
      else
        @posts = Post.where(color: params[:color])
      end
    else # リロードして非選択が生じた場合用
      @posts = Post.all
    end

    @posts = Post.where(is_open: true)

    if user_signed_in?
      blocked_user_ids = current_user.blockings.pluck(:id)
      # ブロックしているユーザーIDsを　　　　取得しない
      @posts = @posts.where.not(user_id: blocked_user_ids)
    end

    case params[:sort_by]
    when "newest"
      @posts = @posts.order(created_at: :desc)
    when "oldest"
      @posts = @posts.order(created_at: :asc)
    when "favorites"
      @posts = @posts.left_outer_joins(:favorites).group(:id).order("COUNT(favorites.id) DESC")
    when "comments"
      @posts = @posts.left_outer_joins(:comments).group(:id).order("COUNT(comments.id) DESC")
    else
      @posts = @posts.order(created_at: :desc)
    end
    # .joinsのみではいいね、コメント数が０のものを取得できないため、left_outer_joins/左外部結合 を使用。
    # 最後に@postsに対してページネーションを実行。
    # １ページあたりの表示数は、config/initializers/kaminari_config.rbに設定していたが、変更容易のためこちらへ。
    @posts = @posts.page(params[:page]).per(12)
  end

  def edit
    # :is_matching_login_user
  end

  def update
    # :is_matching_login_user
    @post.user_id = current_user.id
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private
    def post_params
      params.require(:post).permit(:user_id, :image, :body, :color, :is_open)
    end

    def is_matching_login_user
      @post = Post.find(params[:id])
      unless @post.user == current_user
        redirect_to posts_path
      end
    end
end
