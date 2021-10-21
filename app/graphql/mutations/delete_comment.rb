module Mutations
  class DeleteComment < BaseMutation
    field :successful, Boolean, null: false
    field :errors, [String], null: false

    argument :comment_id, Integer, required: true

    def resolve(args)
      if Comment.exists?(args[:comment_id])
        comment = Comment.find_by_id(args[:comment_id])
        # The total number of replies to a comment that will get removed + the original comment to remove them from ther post comment count
        num_of_replies = comment.replies.count + 1
        Post.subtract_from_num_of_comments(comment.post_id, num_of_replies)

        Comment.destroy(args[:comment_id])

        { 
          successful: true,
          errors: []
        }
      else
        { 
          successful: false,
          errors: ["Comment Id not found"]
        }
      end
    end
  end
end
