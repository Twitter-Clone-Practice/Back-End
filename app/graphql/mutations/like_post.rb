module Mutations
  class LikePost < BaseMutation
    field :success, Boolean, null: true
    field :errors, [String], null: false

    argument :user_id, Integer, required: true
    argument :post_id, Integer, required: true

    def resolve(args)
      post = Post.find_by(id: args[:post_id])
      user = User.find_by(id: args[:user_id])

      # checks if user and post exists
      if post && user
        post_info = PostInfo.find_by(user_id: args[:user_id], post_id: args[:post_id])
        
        # checks if post info exists for the post
        if post_info && post_info.liked == false
          # If found add to number of likes and changes liked to true
          post_info.liked = true
          post.number_of_likes += 1

          post_info.save
          post.save
          
          {
            success: true,
            errors: []
          }
        elsif post_info && post_info.liked == true
          # If post exists and is already liked
          {
            success: false,
            errors: ["Post already liked by user"]
          }
        else
          # If not found creates a new postInfo
          post_info = PostInfo.new(user_id: args[:user_id], post_id: args[:post_id], liked: true)

          if post_info.save
            # If successfully saves add to number of likes
            post.number_of_likes += 1
            post.save
            {
              success: true,
              errors: []
            }
          else
            # Errors
            {
              success: false,
              errors: post_info.errors.full_messages
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
