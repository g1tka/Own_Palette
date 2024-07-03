class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  # 同じ投稿に同じユーザーが再びいいねを押せないようにするため。
  validates_uniqueness_of :post_id, scope: :user_id
end
