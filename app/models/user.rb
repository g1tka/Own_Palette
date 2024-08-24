class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  validates :name, length: { minimum: 1, maximum: 20 }, uniqueness: true
  # emailはdeviseで作成時点でuniqueness: trueとなっているため設定しない。
  validate :check_consecutive_characters

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    followings.include?(user)
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  # if @user.email == "guest@example.com"をmethod化
  def guest_user?
    email == GUEST_USER_EMAIL
  end

  # 自分がブロックされる（被ブロック）側の関係性
  has_many :reverse_of_blocks, class_name: "Block", foreign_key: "blocked_id", dependent: :destroy
  # 被ブロック関係を通じて参照→自分をブロックしている人
  has_many :blockers, through: :reverse_of_blocks, source: :blocker
  # 自分がブロックする（与ブロック）側の関係性
  has_many :blocks, class_name: "Block", foreign_key: "blocker_id", dependent: :destroy
  # 与ブロック関係を通じて参照→自分がブロックしている人
  has_many :blockings, through: :blocks, source: :blocked

  def block(user)
    blocks.create(blocked_id: user.id)
  end

  def unblock(user)
    blocks.find_by(blocked_id: user.id)&.destroy
    # &の存在によりnil.destroyとなった場合実行しない。
  end

  def blocking?(user)
    blockings.include?(user)
  end

  private
    def check_consecutive_characters
      if name.match?(/(.)\1{4,}/)
        errors.add(:name, "に同じ文字が5文字以上連続して使用されています。")
      end
    end
end
