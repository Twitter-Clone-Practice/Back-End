module Mutations
  class DeletePost < BaseMutation
    field :success, Boolean, null: true
    field :errors, [String], null: false

    argument :id, Integer, required: true

    def resolve(args)
      post = Post.find_by_id(args[:id])

      if post
        post.delete

        { 
          success: true,
          errors: []
        }
      else
        { 
          success: false,
          errors: ["post Id not found"]
        }
      end
    end
  end
end
