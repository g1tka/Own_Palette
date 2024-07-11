class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  enum color: { red: 0, orange: 1, yellow: 2, green: 3, blue: 4, purple: 5, monochrome: 6, other: 7 }

  validates :body, presence: true, length: { maximum: 100 }
  validates :color, presence: true
  validate :image_type

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_fill: [200, 200]).processed
  end

  # いいねされているかどうかを確認するメソッドを定義。
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  private

  def image_type
    if !image.blob
      errors.add(:image, 'をアップロードしてください')
    elsif !image.blob.content_type.in?(%('image/jpeg image/png'))
      errors.add(:image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end
end
