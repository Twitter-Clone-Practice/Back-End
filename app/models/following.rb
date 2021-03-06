class Following < ApplicationRecord
  belongs_to :user
  belongs_to :following, class_name: "User"

  validates :user, :following, presence: true
  validates_uniqueness_of :user, scope: :following
end
