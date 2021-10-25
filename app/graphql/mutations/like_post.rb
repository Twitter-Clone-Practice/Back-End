module Mutations
  class LikePost < BaseMutation
    description 'Add the post to a users likes'

    field :successful, Boolean, null: false
    field :errors, [String], null: false

    argument :post_id, Integer, required: true
    argument :user_id, Integer, required: true

    def resolve(args)
      like = Like.new(post_id: args[:post_id], user_id: args[:user_id])
      
      if like.save
        Post.add_to_num_of_likes(args[:post_id])

        { 
          successful: true,
          errors: []
        }
      else
        raise GraphQL::ExecutionError, like.errors.full_messages.join(", ")
      end
    end
  end
end
