module Mutations
  class UnlikePost < BaseMutation
    description 'Unlike a post'

    field :successful, Boolean, null: false
    field :errors, [String], null: false

    argument :like_id, Integer, required: true

    def resolve(args)
      like = Like.find_by_id(args[:like_id])

      if like
        Post.subtract_from_num_of_likes(like.post.id)
        like.destroy

        { 
          successful: true,
          errors: []
        }
      else
        {
          successful: false,
          errors: ['Unable to find ID for like']
        }
      end
    end
  end
end
