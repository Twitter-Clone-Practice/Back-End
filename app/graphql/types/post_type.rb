module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: true
    field :message, String, null: true
    field :number_of_likes, Integer, null: true
    field :number_of_replys, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :comments, [CommentType], null: true
  end
end
