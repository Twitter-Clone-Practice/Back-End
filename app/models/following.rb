class Following < ApplicationRecord
  belongs_to :user
  belongs_to :following, class_name: "User"

  validates :user, :following, presence: true
end
