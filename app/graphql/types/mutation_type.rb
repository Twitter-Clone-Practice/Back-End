module Types
  class MutationType < Types::BaseObject
    field :like_post, mutation: Mutations::LikePost
    field :new_post, mutation: Mutations::NewPost
    field :follow_user, mutation: Mutations::FollowUser
    field :delete_user, mutation: Mutations::DeleteUser
    field :create_user, mutation: Mutations::CreateUser
  end
end
