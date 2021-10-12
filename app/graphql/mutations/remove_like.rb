module Mutations
  class RemoveLike < BaseMutation
    field :success, Boolean, null: true
    field :errors, [String], null: false

    argument :post_info_id, Integer, required: true

    def resolve(args)
      post_info = PostInfo.find_by_id(args[:post_info_id])

      if post_info
        post_info.liked = false
        post_info.save

        { 
          success: true,
          errors: []
        }
      else
        { 
          success: false,
          errors: ["Id not found"]
        }
      end
    end
  end
end
