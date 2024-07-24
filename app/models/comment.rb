class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum stance: { agree: 0, neutral: 1, disagree: 2 }

  validates :body, presence: true, length: { maximum: 100 }
  validates :stance, presence: true
  
  validate :check_consecutive_characters

  private

  def check_consecutive_characters
    if body =~ /(.)\1{4,}/
      errors.add(:body, "に同じ文字が5文字以上連続して使用されています。")
    end
  end
end
