class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :message, presence: true

  def exists?(post_id)
    post = Post.find_by_id(post_id)

    if post
      return true
    else
      return false
    end
  end
end
