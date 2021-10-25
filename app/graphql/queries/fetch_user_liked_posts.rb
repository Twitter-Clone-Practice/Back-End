module Queries
    class FetchUserLikedPosts < Queries::BaseQuery
        type [Types::PostType], null: false
        argument :user_id, Integer, required: true

        def resolve(args)
            Post.joins(:likes).where("likes.user_id = ?", args[:user_id])
        end
    end
end