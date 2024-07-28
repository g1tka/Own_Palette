class User::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    if current_user.present?
      favorite = @post.favorites.new(user_id: current_user.id)
      favorite.save
      # redirect_to request.referer
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = @post.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # redirect_to request.referer
  end
end
