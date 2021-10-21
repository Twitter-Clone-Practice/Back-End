class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  validates :body, presence: true

  def exists?(coment_id)
    comment = Comment.find_by_id(comment_id)

    if comment
      return true
    else
      return false
    end
  end

  def self.new_comment(post_id, user_id, body, parent_id = nil)
    if parent_id == nil || Comment.exists?(parent_id)
      comment = Comment.new(post_id: post_id, user_id: user_id, body: body, parent_id: parent_id)

      if comment.save
        Post.add_to_num_of_comments(post_id)
        {
          comment: comment,
          errors: []
        }
      else
        {
          comment: nil,
          errors: [comment.errors.full_messages]
        }
      end
    else
      {
        comment: nil,
        errors: ["Parent comment does not exists"]
      }
    end
  end
end
