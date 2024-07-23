class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  belongs_to :blocker, class_name: 'User', foreign_key: 'blocker_id'
  belongs_to :blocked, class_name: 'User', foreign_key: 'blocked_id'
end
