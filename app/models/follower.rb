class Follower < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: "User"

  validates :user, :follower, presence: true
  validates_uniqueness_of :user, scope: :follower
end
