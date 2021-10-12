module Mutations
  class NewComment < BaseMutation
    field :comment, Types::CommentType, null: true
    field :errors, [String], null: false

    argument :post_id, Integer, required: true
    argument :user_id, Integer, required: true
    argument :reply, String, required: true

    def resolve(args)
      post = Post.find_by(id: args[:post_id])
      user = User.find_by(id: args[:user_id])

      # checks if user and post exists
      if post && user
        post_info = PostInfo.find_by(user_id: args[:user_id], post_id: args[:post_id])

        #Checks if a post_info entry exists
        if post_info
          new_comment = Comment.new(post_info_id: post_info.id, reply: args[:reply])

          if new_comment.save
            post.number_of_replys += 1
            post.save

            {
              comment: new_comment,
              errors: []
            }
          else
            {
              comment: nil,
              errors: new_comment.errors.full_messages
            }
          end
        else
          post_info = PostInfo.create(user_id: args[:user_id], post_id: args[:post_id])
          new_comment = Comment.new(post_info_id: post_info.id, reply: args[:reply])

          if new_comment.save
            post.number_of_replys += 1
            post.save
            
            {
              comment: new_comment,
              errors: []
            }
          else
            {
              comment: nil,
              errors: new_comment.errors.full_messages
            }
          end
        end
      else
        {
          success: false,
          errors: ["User or post not found"]
        }
      end
    end
  end
end
