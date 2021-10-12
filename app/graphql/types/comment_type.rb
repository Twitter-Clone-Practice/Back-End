module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :post_info_id, Integer, null: false
    field :reply, String, null: true
    field :username, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def username
      object.user.username
    end
  end
end
