module Queries
    class FetchPost < Queries::BaseQuery
        type Types::PostType, null: false

        argument :post_id, Integer, required: true

        def resolve(args)
            Post.find_by_id(args[:post_id])
        end
    end
end