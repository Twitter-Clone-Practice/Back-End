module Types
  class MutationType < Types::BaseObject
    field :unfollow_user, mutation: Mutations::UnfollowUser
    field :unlike_post, mutation: Mutations::UnlikePost
    field :like_post, mutation: Mutations::LikePost
    field :delete_comment, mutation: Mutations::DeleteComment
    field :new_comment, mutation: Mutations::NewComment
    field :new_post, mutation: Mutations::NewPost
    field :follow_user, mutation: Mutations::FollowUser
    field :delete_user, mutation: Mutations::DeleteUser
    field :create_user, mutation: Mutations::CreateUser
  end
end
