module Mutations
  class NewPost < BaseMutation
    field :post, Types::PostType, null: true
    field :errors, [String], null: false

    argument :user_id, Integer, required: true
    argument :message, String, required: true

    def resolve(args)
      new_post = Post.new(user_id: args[:user_id], message: args[:message])

      if new_post.save
        {
          post: new_post,
          errors: []
        }
      else
        {
          post: nil,
          errors: new_post.errors.full_messages
        }
      end
    end
  end
end
