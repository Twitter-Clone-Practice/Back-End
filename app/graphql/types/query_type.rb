module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    
    field :users, [Types::UserType], null: false 
    
    def users 
      User.all
    end

    field :user, Types::UserType, null: false do 
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end

    field :fetch_user_liked_posts, resolver: Queries::FetchUserLikedPosts
    field :fetch_post, resolver: Queries::FetchPost
  end
end
