module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :post_id, Integer, null: false
    field :user_id, Integer, null: false
    field :body, String, null: true
    field :parent_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :replies, [CommentType], null: true
  end
end
