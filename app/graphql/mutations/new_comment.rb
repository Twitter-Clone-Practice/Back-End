module Mutations
  class NewComment < BaseMutation
    field :comment, Types::CommentType, null: true
    field :errors, [String], null: false

    argument :post_id, Integer, required: true
    argument :user_id, Integer, required: true
    argument :parent_id, Integer, required: false
    argument :body, String, required: true

    def resolve(args)
      if Post.exists?(args[:post_id]) && User.exists?(args[:user_id])
        if args.key?(:parent_id)
          Comment.new_comment(args[:post_id], args[:user_id], args[:body], args[:parent_id])
        else
          Comment.new_comment(args[:post_id], args[:user_id], args[:body])
        end
      else
        {
          comment: nil,
          errors: ["Post or User does not exist"]
        }
      end
    end
  end
end
