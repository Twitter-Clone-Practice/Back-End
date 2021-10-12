module Mutations
  class DeleteComment < BaseMutation
    field :success, Boolean, null: true
    field :errors, [String], null: false

    argument :id, Integer, required: true

    def resolve(args)
      comment = Comment.find_by(id: args[:id])

      if comment
        # Get and remove one from number of replies from the original post
        original_post = comment.post
        original_post.number_of_replys -= 1
        original_post.save

        comment.delete
        
        {
          success: true,
          errors: []
        }
      else
        { 
          success: false,
          errors: ["Comment not found"]
        }
      end
    end
  end
end
