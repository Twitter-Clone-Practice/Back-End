module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :username, String, null: true
    field :email, String, null: true
    field :date_of_birth, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :follower, [UserType], null: true
    field :following, [UserType], null: true
    field :posts, [PostType], null: true
    field :liked_posts, [PostType], null: true

    def liked_posts
      Post.joins(:likes).where("likes.user_id = ?", object.id )
    end
  end
end
