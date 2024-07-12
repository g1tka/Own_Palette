class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum stance: { agree: 0, neutral: 1, disagree: 2 }

  validates :body, presence: true, length: { maximum: 100 }
  validates :stance, presence: true
end
