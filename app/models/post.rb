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

  def self.add_to_num_of_comments(post_id)
    post = self.find_by_id(post_id)

    post.number_of_comments += 1

    post.save
  end
end
